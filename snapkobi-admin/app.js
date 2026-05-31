const state = { token: '', apiBase: '', supabaseUrl: '', supabaseAnonKey: '', templates: [], aiConfigs: [], creditRules: null };
const $ = (selector) => document.querySelector(selector);
const emptyToNull = (value) => value?.trim() || null;
const message = (text, isError = false) => {
  const target = $('#adminView').classList.contains('hidden') ? $('#loginMessage') : $('#adminMessage');
  target.textContent = text;
  target.className = `message ${isError ? 'error' : 'success'}`;
};

async function api(path, options = {}) {
  const response = await fetch(`${state.apiBase}${path}`, {
    ...options,
    headers: { Authorization: `Bearer ${state.token}`, 'Content-Type': 'application/json', ...options.headers },
  });
  if (!response.ok) throw new Error((await response.text()) || `HTTP ${response.status}`);
  return response.status === 204 ? null : response.json();
}

async function loadPublicConfig() {
  const apiBase = $('#backendUrl').value.replace(/\/$/, '');
  const configMessage = $('#configMessage');
  configMessage.textContent = 'Backend ayarlari yukleniyor...';
  configMessage.className = 'message';
  try {
    const response = await fetch(`${apiBase}/public-config`, { cache: 'no-store' });
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    const config = await response.json();
    if (!config.supabaseUrl || !config.supabaseAnonKey) throw new Error('Eksik Supabase ayari');
    state.apiBase = apiBase;
    state.supabaseUrl = config.supabaseUrl.replace(/\/$/, '');
    state.supabaseAnonKey = config.supabaseAnonKey;
    localStorage.setItem('snapkobiAdminConfig', JSON.stringify({ apiBase }));
    configMessage.textContent = 'Backend ayarlari .env dosyasindan yuklendi.';
    configMessage.className = 'message success';
    return true;
  } catch (error) {
    state.supabaseUrl = '';
    state.supabaseAnonKey = '';
    configMessage.textContent = `Backend ayarlari alinamadi: ${error.message}`;
    configMessage.className = 'message error';
    return false;
  }
}

async function completeLogin(token) {
  state.token = token;
  await loadBootstrap();
  $('#loginView').classList.add('hidden');
  $('#adminView').classList.remove('hidden');
  $('#logoutButton').classList.remove('hidden');
  history.replaceState(null, '', location.pathname);
  message('Admin paneli hazir.');
}

$('#loginForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  try {
    if (!state.supabaseUrl || state.apiBase !== $('#backendUrl').value.replace(/\/$/, '')) {
      if (!await loadPublicConfig()) throw new Error('Backend ayarlari yuklenemedi.');
    }
    const response = await fetch(`${state.supabaseUrl}/auth/v1/token?grant_type=password`, {
      method: 'POST',
      headers: { apikey: state.supabaseAnonKey, 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: $('#email').value, password: $('#password').value }),
    });
    if (!response.ok) {
      const authError = await response.json().catch(() => ({}));
      const detail = authError.msg || authError.message || authError.error_description || `HTTP ${response.status}`;
      throw new Error(`Supabase girisi basarisiz: ${detail}`);
    }
    const session = await response.json();
    await completeLogin(session.access_token);
  } catch (error) { message(error.message, true); }
});

$('#googleLoginButton').addEventListener('click', async () => {
  if (!state.supabaseUrl && !await loadPublicConfig()) {
    message('Backend ayarlari yuklenemedi.', true);
    return;
  }
  const redirectTo = `${location.origin}${location.pathname}`;
  const params = new URLSearchParams({ provider: 'google', redirect_to: redirectTo });
  location.assign(`${state.supabaseUrl}/auth/v1/authorize?${params}`);
});

$('#logoutButton').addEventListener('click', () => location.reload());
document.querySelectorAll('.tab').forEach((tab) => tab.addEventListener('click', () => {
  document.querySelectorAll('.tab').forEach((item) => item.classList.toggle('active', item === tab));
  document.querySelectorAll('.tab-content').forEach((item) => item.classList.add('hidden'));
  $(`#${tab.dataset.tab}Tab`).classList.remove('hidden');
}));

async function loadBootstrap() {
  const data = await api('/admin/bootstrap');
  state.templates = data.templates;
  state.aiConfigs = data.aiConfigs;
  state.creditRules = data.creditRules;
  renderTemplates();
  renderProviders();
  renderCreditRules();
}

function renderTemplates() {
  $('#templateList').innerHTML = state.templates.map((template) => `
    <article class="card">
      <h3>${escapeHtml(template.name)}</h3>
      <span class="badge">${escapeHtml(template.category)}</span>
      ${template.isFeatured ? '<span class="badge">One Cikan</span>' : ''}
      <p>${escapeHtml(template.description || 'Aciklama yok')}</p>
      <div class="card-actions">
        <button class="button secondary" data-edit-template="${template.id}">Duzenle</button>
        <button class="button danger" data-delete-template="${template.id}">Sil</button>
      </div>
    </article>`).join('') || '<p>Henuz sablon yok.</p>';

  document.querySelectorAll('[data-edit-template]').forEach((button) => button.addEventListener('click', () => openTemplate(button.dataset.editTemplate)));
  document.querySelectorAll('[data-delete-template]').forEach((button) => button.addEventListener('click', () => deleteTemplate(button.dataset.deleteTemplate)));
}

function renderProviders() {
  $('#providerList').innerHTML = state.aiConfigs.map((config) => `
    <form class="card provider-form" data-task-type="${config.taskType}">
      <h3>${escapeHtml(config.taskType.toUpperCase())}</h3>
      ${config.taskType === 'video' && !config.effectiveApiKeyConfigured
        ? '<p class="provider-warning">Video uretimi icin etkin API anahtari yok. Pollinations anahtarini girip kaydedin.</p>'
        : ''}
      <div class="provider-grid">
        <label>Saglayici<input name="provider" required value="${escapeHtml(config.provider)}" list="providers" /></label>
        <label>Model<input name="activeModel" required value="${escapeHtml(config.activeModel)}" /></label>
        <label>API URL<input name="apiUrl" type="url" value="${escapeHtml(config.apiUrl || '')}" /></label>
        <label>API Key<input name="apiKey" type="password" placeholder="${config.apiKey ? 'Kayitli anahtari koru' : 'Anahtar girin'}" /></label>
      </div>
      <button class="button primary" type="submit">Kaydet</button>
    </form>`).join('') + '<datalist id="providers"><option value="pollinations"><option value="fal"><option value="gemini"><option value="openai"></datalist>';
  document.querySelectorAll('.provider-form').forEach((form) => form.addEventListener('submit', saveProvider));
}

async function saveProvider(event) {
  event.preventDefault();
  const form = event.currentTarget;
  const values = Object.fromEntries(new FormData(form));
  await api(`/ai-configs/${form.dataset.taskType}`, {
    method: 'PUT',
    body: JSON.stringify({ provider: values.provider, activeModel: values.activeModel, apiUrl: emptyToNull(values.apiUrl), apiKey: emptyToNull(values.apiKey) || undefined }),
  });
  message(`${form.dataset.taskType} ayari kaydedildi.`);
  await loadBootstrap();
}

function renderCreditRules() {
  const rules = state.creditRules || { plans: { free: 5, starter: 100, pro: 500 }, costs: { image: 1, video: 1, caption: 0 } };
  Object.entries({ ...rules.plans, ...rules.costs }).forEach(([key, value]) => { $('#creditForm').elements[key].value = value; });
}

$('#creditForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const form = event.currentTarget.elements;
  const value = {
    plans: { free: +form.free.value, starter: +form.starter.value, pro: +form.pro.value },
    costs: { image: +form.image.value, video: +form.video.value, caption: +form.caption.value },
  };
  await api('/admin/settings/credit-rules', { method: 'PUT', body: JSON.stringify({ value }) });
  message('Kredi kurallari kaydedildi.');
  await loadBootstrap();
});

$('#newTemplateButton').addEventListener('click', () => openTemplate());
$('#closeTemplateButton').addEventListener('click', () => $('#templateDialog').close());
$('#templateForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const form = event.currentTarget;
  const values = Object.fromEntries(new FormData(form));
  const payload = {
    name: values.name, slug: values.slug, description: emptyToNull(values.description),
    thumbnailUrl: emptyToNull(values.thumbnailUrl), category: values.category, sortOrder: +values.sortOrder,
    applicablePlatforms: values.applicablePlatforms.split(',').map((item) => item.trim()).filter(Boolean),
    defaultBackgroundStyle: values.defaultBackgroundStyle, backgroundSystemPrompt: emptyToNull(values.backgroundSystemPrompt),
    videoSystemPrompt: emptyToNull(values.videoSystemPrompt), captionSystemPrompt: emptyToNull(values.captionSystemPrompt),
    captionUserPromptSuffix: emptyToNull(values.captionUserPromptSuffix), isActive: form.elements.isActive.checked,
    isFeatured: form.elements.isFeatured.checked,
  };
  await api(values.id ? `/admin/templates/${values.id}` : '/admin/templates', { method: values.id ? 'PUT' : 'POST', body: JSON.stringify(payload) });
  $('#templateDialog').close();
  message('Sablon kaydedildi.');
  await loadBootstrap();
});

function openTemplate(id) {
  const template = state.templates.find((item) => item.id === id);
  const form = $('#templateForm');
  form.reset();
  Object.entries(template || {}).forEach(([key, value]) => {
    if (!form.elements[key]) return;
    if (form.elements[key].type === 'checkbox') form.elements[key].checked = value;
    else form.elements[key].value = Array.isArray(value) ? value.join(',') : value ?? '';
  });
  $('#templateDialog').showModal();
}

async function deleteTemplate(id) {
  if (!confirm('Bu sablon silinsin mi?')) return;
  await api(`/admin/templates/${id}`, { method: 'DELETE' });
  message('Sablon silindi.');
  await loadBootstrap();
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (char) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[char]));
}

const saved = JSON.parse(localStorage.getItem('snapkobiAdminConfig') || '{}');
if (saved.apiBase) $('#backendUrl').value = saved.apiBase;
$('#backendUrl').addEventListener('change', loadPublicConfig);
await loadPublicConfig();

const oauthParams = new URLSearchParams(location.hash.slice(1));
if (oauthParams.get('access_token')) {
  completeLogin(oauthParams.get('access_token')).catch((error) => message(error.message, true));
} else if (oauthParams.get('error_description')) {
  message(`Google girisi basarisiz: ${oauthParams.get('error_description')}`, true);
  history.replaceState(null, '', location.pathname);
}
