import app from './app';
import { env } from './config/env';

const start = async () => {
  try {
    const port = env.PORT;
    const host = '0.0.0.0';
    
    await app.listen({ port, host });
    console.log(`🚀 Server listening on http://${host}:${port}`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
