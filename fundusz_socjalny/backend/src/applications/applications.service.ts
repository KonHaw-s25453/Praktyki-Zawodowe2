import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Application } from './entities/application.entity.js';
import { CreateApplicationDto } from './dto/create-application.dto.js';

@Injectable()
export class ApplicationsService {
    constructor(
        @InjectRepository(Application)
        private readonly applicationRepository: Repository<Application>,
    ) {}

    findAll(): Promise<Application[]> {
        return this.applicationRepository.find();
    }

    findOne(id: string): Promise<Application | null> {
        return this.applicationRepository.findOneBy({applicationId: id,});
    }

    create(createApplicationDto: CreateApplicationDto): Promise<Application> {
    const application = this.applicationRepository.create(createApplicationDto);
        return this.applicationRepository.save(application);
    }
    }