import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { DocumentType } from './entities/document_type.entity.js';

@Module({
    imports: [
        TypeOrmModule.forFeature([
            DocumentType,
        ]),
    ],
})
export class DocumentsModule {}