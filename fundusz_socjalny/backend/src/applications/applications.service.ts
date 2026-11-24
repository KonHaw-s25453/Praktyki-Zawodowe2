import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Application } from './entities/application.entity.js';

@Injectable()
export class ApplicationsService {
    constructor(
        @InjectRepository(Application)
        private readonly applicationRepository: Repository<Application>,
    ) {}

    findAll(): Promise<Application[]> {
        return this.applicationRepository.find();
    }

}