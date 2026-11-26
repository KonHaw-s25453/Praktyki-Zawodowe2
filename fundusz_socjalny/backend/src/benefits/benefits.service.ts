import { Injectable, NotFoundException, ConflictException} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, QueryFailedError } from 'typeorm';
import { CreateBenefitTypeDto } from './dto/create-benefit-type.dto.js';
import { UpdateBenefitTypeDto } from './dto/update-benefit-type.dto.js';
import { BenefitType } from './entities/benefit-type.entity.js';


@Injectable()
export class BenefitsService {

    constructor(
        @InjectRepository(BenefitType)
        private readonly benefitTypeRepository: Repository<BenefitType>,
    ) {}

    async findAll(): Promise<BenefitType[]> {
    return this.benefitTypeRepository.find();
}

async findOne(id: string): Promise<BenefitType> {
    const benefitType = await this.benefitTypeRepository.findOneBy({
        benefitTypeId: id,
    });

    if (!benefitType) {
        throw new NotFoundException(
            `Benefit type with ID ${id} not found`,
        );
    }

    return benefitType;
}

async create(createBenefitTypeDto: CreateBenefitTypeDto): Promise<BenefitType> {
    try {
        const benefitType = this.benefitTypeRepository.create(createBenefitTypeDto);

        return await this.benefitTypeRepository.save(benefitType);
    } catch (error) {
        if (
            error instanceof QueryFailedError &&
            (error.driverError as { code?: string }).code === 'ER_DUP_ENTRY'
        ) {
            throw new ConflictException(
                'A benefit type with this code already exists.',
            );
        }

        throw error;
    }
}

async update(
    id: string,
    updateBenefitTypeDto: UpdateBenefitTypeDto,
): Promise<BenefitType> {
    const benefitType = await this.findOne(id);

    Object.assign(benefitType, updateBenefitTypeDto);

    try {
        return await this.benefitTypeRepository.save(benefitType);
    } catch (error) {
        if (
            error instanceof QueryFailedError &&
            (error.driverError as { code?: string }).code === 'ER_DUP_ENTRY'
        ) {
            throw new ConflictException(
                'A benefit type with this code already exists.',
            );
        }

        throw error;
    }
}

async deactivate(id: string): Promise<BenefitType> {
    const benefitType = await this.findOne(id);

    benefitType.isActive = false;

    return this.benefitTypeRepository.save(benefitType);
}

}

