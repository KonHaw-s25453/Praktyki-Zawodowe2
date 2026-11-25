import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module.js';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
const app = await NestFactory.create(AppModule);

app.useGlobalPipes(
    new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }),
);

const swaggerConfig = new DocumentBuilder()
.setTitle('Fundusz Socjalny API')
.setDescription('Dokumentacja API systemu Funduszu Socjalnego')
.setVersion('1.0')
.build();

const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);
SwaggerModule.setup('api', app, swaggerDocument);

const port = process.env.PORT ?? 3000;
await app.listen(port);

console.log('');
console.log('========================================');
console.log('       FUNDUSZ SOCJALNY - BACKEND');
console.log('========================================');
console.log('');
console.log(`  Backend:    http://localhost:${port}`);
console.log(`  Swagger:    http://localhost:${port}/api`);
console.log(`  API-JSON:   http://localhost:${port}/api-json`);
console.log('');
console.log('========================================');
console.log('  Application successfully started!');
console.log('========================================');

}

await bootstrap();