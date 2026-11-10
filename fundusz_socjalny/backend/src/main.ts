import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module.js';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
const app = await NestFactory.create(AppModule);

const swaggerConfig = new DocumentBuilder()
.setTitle('Fundusz Socjalny API')
.setDescription('Dokumentacja API systemu Funduszu Socjalnego')
.setVersion('1.0')
.build();

const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);
SwaggerModule.setup('api', app, swaggerDocument);

await app.listen(process.env.PORT ?? 3000);
}

await bootstrap();