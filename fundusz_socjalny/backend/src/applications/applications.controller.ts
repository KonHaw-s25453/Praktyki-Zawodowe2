import { Controller, Get, Param, Post, Body } from '@nestjs/common';
import { ApplicationsService } from './applications.service.js';
import { CreateApplicationDto } from './dto/create-application.dto.js';

@Controller('applications')
export class ApplicationsController {
    constructor(private readonly applicationsService: ApplicationsService) {}

     @Get()
    findAll() {
        return this.applicationsService.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.applicationsService.findOne(id);
    }
    @Post()
    create(@Body() createApplicationDto: CreateApplicationDto) {
    return this.applicationsService.create(createApplicationDto);
}
}

