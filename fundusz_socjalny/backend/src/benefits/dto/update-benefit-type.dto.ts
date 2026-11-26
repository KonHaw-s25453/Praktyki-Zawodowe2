import { PartialType } from '@nestjs/swagger';
import { CreateBenefitTypeDto } from './create-benefit-type.dto.js';

export class UpdateBenefitTypeDto extends PartialType(CreateBenefitTypeDto,{ skipNullProperties: false }) {}