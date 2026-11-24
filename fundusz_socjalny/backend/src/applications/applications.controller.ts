import { Controller, Get } from '@nestjs/common';
import { ApplicationsService } from './applications.service.js';

@Controller('applications')
export class ApplicationsController {
    constructor(private readonly applicationsService: ApplicationsService) {}

     @Get()
    findAll() {
        return this.applicationsService.findAll();
    }
}

