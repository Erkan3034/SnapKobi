export const DEFAULT_AI_CONFIGS = [
  {
    taskType: 'image',
    activeModel: 'pollinations',
    apiUrl: 'https://image.pollinations.ai/prompt',
  },
  {
    taskType: 'caption',
    activeModel: 'gemini-flash',
    apiUrl: 'https://generativelanguage.googleapis.com',
  },
  {
    taskType: 'video',
    activeModel: 'fal-kaiber',
    apiUrl: 'https://fal.run/fal-ai/luma-dream-machine',
  },
];
