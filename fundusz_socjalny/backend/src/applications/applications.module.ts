import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Application } from './entities/application.entity.js';
import { ApplicationDocument } from './entities/application_document.entity.js';
import { ApplicationStatusHistory } from './entities/application_status_history.entity.js';
import { ApplicationVersion } from './entities/application_version.entity.js';

import { ApplicationsController } from './applications.controller.js';
import { ApplicationsService } from './applications.service.js';

@Module({
    imports: [
        TypeOrmModule.forFeature([
            Application,
            ApplicationDocument,
            ApplicationStatusHistory,
            ApplicationVersion,
        ]),
    ],
    providers: [ApplicationsService],
    controllers: [ApplicationsController],
})
export class ApplicationsModule {}