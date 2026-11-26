import { Controller, Get, Param, Post, Body, Patch } from '@nestjs/common';
import { BenefitsService } from './benefits.service.js';
import { CreateBenefitTypeDto } from './dto/create-benefit-type.dto.js';
import { UpdateBenefitTypeDto } from './dto/update-benefit-type.dto.js';
import { BenefitTypeResponseDto } from './dto/benefit-type-response.dto.js';
import { ApiTags, ApiOperation, ApiOkResponse, ApiCreatedResponse, ApiParam, ApiBody, ApiNotFoundResponse, ApiConflictResponse} from '@nestjs/swagger';

@ApiTags('benefits')
@Controller('benefits')
export class BenefitsController {

   constructor(
        private readonly benefitsService: BenefitsService,
    ) {}

@ApiOperation({ summary: 'Pobierz wszystkie rodzaje świadczeń' })
@ApiOkResponse({
    description: 'Lista rodzajów świadczeń',
    type: BenefitTypeResponseDto,
    isArray: true,
})
@Get()
findAll() {
    return this.benefitsService.findAll();
}

@ApiOperation({ summary: 'Pobierz rodzaj świadczenia po ID' })
@ApiParam({ name: 'id', description: 'ID rodzaju świadczenia',example: '1' })
@ApiOkResponse({
    description: 'Szczegóły rodzaju świadczenia',
    type: BenefitTypeResponseDto,
})
@ApiNotFoundResponse({
    description: 'Nie znaleziono rodzaju świadczenia o podanym ID',
})
@Get(':id')
findOne(@Param('id') id: string) {
    return this.benefitsService.findOne(id);
}

@ApiOperation({ summary: 'Utwórz nowy rodzaj świadczenia' })
@ApiBody({
    type: CreateBenefitTypeDto,
    description: 'Dane nowego rodzaju świadczenia',
})
@ApiCreatedResponse({
    description: 'Utworzono nowy rodzaj świadczenia',
    type: BenefitTypeResponseDto,
})
@ApiConflictResponse({
    description: 'Rodzaj świadczenia o podanym kodzie już istnieje',
})
@Post()
create(@Body() createBenefitTypeDto: CreateBenefitTypeDto) {
    return this.benefitsService.create(createBenefitTypeDto);
}

@ApiOperation({ summary: 'Zaktualizuj rodzaj świadczenia' })
@ApiParam({name: 'id', description: 'Identyfikator rodzaju świadczenia', example: '1',
})
@ApiBody({
    type: UpdateBenefitTypeDto,
    description: 'Dane do aktualizacji rodzaju świadczenia',
})
@ApiNotFoundResponse({
    description: 'Nie znaleziono rodzaju świadczenia o podanym ID',
})
@ApiOkResponse({
    description: 'Zaktualizowano rodzaj świadczenia',
    type: BenefitTypeResponseDto,
})
@Patch(':id')
update(
    @Param('id') id: string,
    @Body() updateBenefitTypeDto: UpdateBenefitTypeDto,
) {
    return this.benefitsService.update(id, updateBenefitTypeDto);
}

@ApiOperation({ summary: 'Dezaktywuj rodzaj świadczenia' })
@ApiParam({name: 'id', description: 'Identyfikator rodzaju świadczenia', example: '1' })
@ApiNotFoundResponse({
    description: 'Nie znaleziono rodzaju świadczenia o podanym ID',
})@ApiOkResponse({
    description: 'Dezaktywowano rodzaj świadczenia',
    type: BenefitTypeResponseDto,
})
@Patch(':id/deactivate')
deactivate(@Param('id') id: string) {
    return this.benefitsService.deactivate(id);
}

}