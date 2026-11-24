import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  Check,
  ManyToOne,
  JoinColumn,
} from 'typeorm';

import { BenefitType } from './benefit-type.entity.js';

@Entity('benefit_periods')

@Index(
  'uq_benefit_period_code',
  ['benefitTypeId', 'periodCode'],
  { unique: true },
)
@Index('idx_benefit_period_status', ['periodStatus'])
@Index('idx_benefit_period_dates', ['startDate', 'endDate'])

@Check('chk_benefit_period_dates', '`end_date` >= `start_date`')

@Check(
  'chk_benefit_application_dates',
  '`application_close_at` IS NULL OR `application_open_at` IS NULL OR `application_close_at` >= `application_open_at`',
)

@Check(
  'chk_benefit_period_status',
  "`period_status` IN ('DRAFT', 'OPEN', 'CLOSED', 'ARCHIVED')",
)

export class BenefitPeriod {

  @PrimaryGeneratedColumn({
    name: 'benefit_period_id',
    type: 'bigint',
    unsigned: true,
  })
  benefitPeriodId: string;

  @Column({
    name: 'benefit_type_id',
    type: 'bigint',
    unsigned: true,
  })
  benefitTypeId: string;

  @ManyToOne(
    () => BenefitType,
    { nullable: false, onUpdate: 'RESTRICT', onDelete: 'RESTRICT' },
  )
  @JoinColumn({
    name: 'benefit_type_id',
    referencedColumnName: 'benefitTypeId',
    foreignKeyConstraintName: 'fk_benefit_periods_type',
  })
  benefitType: BenefitType;

  @Column({
    name: 'period_code',
    type: 'varchar',
    length: 50,
  })
  periodCode: string;

  @Column({
    name: 'period_name',
    type: 'varchar',
    length: 150,
  })
  periodName: string;

  @Column({
    name: 'start_date',
    type: 'date',
  })
  startDate: string;

  @Column({
    name: 'end_date',
    type: 'date',
  })
  endDate: string;

  @Column({
    name: 'benefit_date',
    type: 'date',
    nullable: true,
  })
  benefitDate: string | null;

  @Column({
    name: 'application_open_at',
    type: 'datetime',
    nullable: true,
  })
  applicationOpenAt: Date | null;

  @Column({
    name: 'application_close_at',
    type: 'datetime',
    nullable: true,
  })
  applicationCloseAt: Date | null;

  @Column({
    name: 'period_status',
    type: 'varchar',
    length: 20,
    default: 'DRAFT',
  })
  periodStatus: string;

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