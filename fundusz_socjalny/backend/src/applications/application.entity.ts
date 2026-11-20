import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  Check,
} from 'typeorm';

import { Employee } from '../employees/employee.entity.js';
import { BenefitPeriod } from '../benefit_period/benefit-period.entity.js';

@Entity('applications')
@Index('idx_applications_employee', ['employeeId'])
@Index('idx_applications_period', ['benefitPeriodId'])
@Index('idx_applications_status', ['currentStatus'])
@Index('idx_applications_employee_status', ['employeeId', 'currentStatus'])
@Check(
  'chk_applications_status',
  "`current_status` IN ('DRAFT', 'SUBMITTED', 'UNDER_REVIEW', 'REQUIRES_CORRECTION', 'APPROVED', 'REJECTED', 'WITHDRAWN')",
)
export class Application {
    @PrimaryGeneratedColumn({
  name: 'application_id',
  type: 'bigint',
  unsigned: true,
})
applicationId: string;

@Column({
  name: 'employee_id',
  type: 'bigint',
  unsigned: true,
})
employeeId: string;

@Column({
  name: 'benefit_period_id',
  type: 'bigint',
  unsigned: true,
})
benefitPeriodId: string;

@ManyToOne(() => Employee, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'employee_id',
  referencedColumnName: 'employeeId',
})
employee: Employee;

@ManyToOne(() => BenefitPeriod, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'benefit_period_id',
  referencedColumnName: 'benefitPeriodId',
})
benefitPeriod: BenefitPeriod;

@Column({
  name: 'current_status',
  type: 'varchar',
  length: 30,
  default: 'DRAFT',
})
currentStatus: string;

@CreateDateColumn({
  name: 'created_at',
  type: 'datetime',
})
createdAt: Date;

@UpdateDateColumn({
  name: 'updated_at',
  type: 'datetime',
})
updatedAt: Date;

@Column({
  name: 'submitted_at',
  type: 'datetime',
  nullable: true,
})
submittedAt: Date | null;

}