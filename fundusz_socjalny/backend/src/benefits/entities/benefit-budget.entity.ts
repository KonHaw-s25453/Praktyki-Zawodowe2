import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Check,
  OneToOne,
  JoinColumn,
} from 'typeorm';

import { BenefitPeriod } from './benefit_period.entity.js';

@Entity('benefit_budgets')

@Check('chk_benefit_budget_amount', '`budget_amount` >= 0')

@Check(
  'chk_benefit_warning_threshold',
  '`warning_threshold_percent` >= 0 AND `warning_threshold_percent` <= 100',
)

export class BenefitBudget {

  @PrimaryGeneratedColumn({
    name: 'budget_id',
    type: 'bigint',
    unsigned: true,
  })
  budgetId: string;

  @Column({
    name: 'benefit_period_id',
    type: 'bigint',
    unsigned: true,
  })
  benefitPeriodId: string;

  @OneToOne(
    () => BenefitPeriod,
    { nullable: false, onUpdate: 'RESTRICT', onDelete: 'RESTRICT' },
  )
  @JoinColumn({
    name: 'benefit_period_id',
    referencedColumnName: 'benefitPeriodId',
    foreignKeyConstraintName: 'fk_benefit_budgets_period',
  })
  benefitPeriod: BenefitPeriod;

  @Column({
    name: 'budget_amount',
    type: 'decimal',
    precision: 12,
    scale: 2,
  })
  budgetAmount: string;

  @Column({
    name: 'warning_threshold_percent',
    type: 'decimal',
    precision: 5,
    scale: 2,
    default: 80.00,
  })
  warningThresholdPercent: string;

  @Column({
    name: 'notes',
    type: 'text',
    nullable: true,
  })
  notes: string | null;

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