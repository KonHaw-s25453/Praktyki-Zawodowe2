import { IsString, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateApplicationDto {

    @ApiProperty({
        description: 'Identyfikator pracownika',
        example: '15',
    })
    @IsString()
    @IsNotEmpty()
    employeeId: string;

    @ApiProperty({
        description: 'Identyfikator okresu świadczeniowego',
        example: '2023-2024',
    })
    @IsString()
    @IsNotEmpty()
    benefitPeriodId: string;

}