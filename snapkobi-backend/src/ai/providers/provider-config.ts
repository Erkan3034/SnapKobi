export interface AiProviderConfig {
  provider: string;
  activeModel: string;
  apiKey?: string | null;
  apiUrl?: string | null;
  settings?: unknown;
}
