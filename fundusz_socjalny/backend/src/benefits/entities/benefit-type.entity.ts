import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('benefit_types')
@Index('uq_benefit_types_code', ['benefitCode'], { unique: true })
@Index('idx_benefit_types_name', ['benefitName'])
export class BenefitType {

  @PrimaryGeneratedColumn({
    name: 'benefit_type_id',
    type: 'bigint',
    unsigned: true,
  })
  benefitTypeId: string;

  @Column({
    name: 'benefit_code',
    type: 'varchar',
    length: 50,
  })
  benefitCode: string;

  @Column({
    name: 'benefit_name',
    type: 'varchar',
    length: 150,
  })
  benefitName: string;

  @Column({
    name: 'description',
    type: 'text',
    nullable: true,
  })
  description: string | null;

  @Column({
    name: 'is_active',
    type: 'boolean',
    default: true,
  })
  isActive: boolean;

  @CreateDateColumn({
    name: 'created_at',
    type: 'datetime',
    default: () => 'CURRENT_TIMESTAMP',
  })
  createdAt: Date;

  @UpdateDateColumn({
    name: 'updated_at',
    type: 'datetime',
    default: () => 'CURRENT_TIMESTAMP',
    onUpdate: 'CURRENT_TIMESTAMP',
  })
  updatedAt: Date;
}