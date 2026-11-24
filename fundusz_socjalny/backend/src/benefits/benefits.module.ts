import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { BenefitType } from './entities/benefit-type.entity.js';
import { BenefitPeriod } from './entities/benefit_period.entity.js';
import { BenefitBudget } from './entities/benefit-budget.entity.js';
import { BenefitFormVersion } from './entities/benefit_form_version.entity.js';
import { BenefitRequiredDocument } from './entities/benefit_required_document.entity.js';

@Module({
    imports: [
        TypeOrmModule.forFeature([
            BenefitType,
            BenefitPeriod,
            BenefitBudget,
            BenefitFormVersion,
            BenefitRequiredDocument,
        ]),
    ],
})
export class BenefitsModule {}
