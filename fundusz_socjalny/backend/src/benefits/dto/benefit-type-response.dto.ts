import { ApiProperty } from '@nestjs/swagger';

export class BenefitTypeResponseDto {

    @ApiProperty({ example: '5' })
    benefitTypeId: string;

    @ApiProperty({ example: 'HOLIDAY' })
    benefitCode: string;

    @ApiProperty({ example: 'Świadczenie urlopowe' })
    benefitName: string;

    @ApiProperty({
        example: 'Dofinansowanie wypoczynku pracownika',
        nullable: true,
    })
    description: string | null;

    @ApiProperty({ example: false })
    isActive: boolean;

    @ApiProperty({ example: '2026-11-26T18:45:16.000Z' })
    createdAt: Date;

    @ApiProperty({ example: '2026-11-26T18:51:49.000Z' })
    updatedAt: Date;
}