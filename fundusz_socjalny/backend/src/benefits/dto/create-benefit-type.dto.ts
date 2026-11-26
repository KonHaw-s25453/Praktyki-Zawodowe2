import {
    IsString,
    IsNotEmpty,
    MaxLength,
    IsOptional,
    IsBoolean,
    ValidateIf,
} from 'class-validator';
import {
    ApiProperty,
    ApiPropertyOptional,
} from '@nestjs/swagger';

export class CreateBenefitTypeDto {

    @ApiProperty({
        description: 'Unikalny kod rodzaju świadczenia',
        example: 'HOLIDAY',
        maxLength: 50,
    })
    @IsString()
    @IsNotEmpty()
    @MaxLength(50)
    benefitCode: string;

    @ApiProperty({
        description: 'Nazwa rodzaju świadczenia',
        example: 'Świadczenie urlopowe',
        maxLength: 150,
    })
    @IsString()
    @IsNotEmpty()
    @MaxLength(150)
    benefitName: string;

    @ApiPropertyOptional({
        description: 'Opis rodzaju świadczenia',
        example: 'Dofinansowanie wypoczynku pracownika',
        nullable: true,
    })
    @IsOptional()
    @IsString()
    description?: string | null;

    @ApiPropertyOptional({
        description: 'Czy rodzaj świadczenia jest aktywny',
        example: true,
        default: true,
    })
    @ValidateIf((_, value) => value !== undefined)
    @IsBoolean()
    isActive?: boolean;
}