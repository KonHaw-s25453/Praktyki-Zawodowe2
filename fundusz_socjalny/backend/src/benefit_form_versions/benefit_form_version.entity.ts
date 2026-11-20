import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  Check,
} from 'typeorm';

import { BenefitType } from '../benefit-type/benefit-type.entity.js';
import { User } from '../users/user.entity.js';

@Entity('benefit_form_versions')
@Index(
  'uq_benefit_form_version',
  ['benefitTypeId', 'versionNo'],
  { unique: true },
)
@Index(
  'idx_benefit_form_dates',
  ['benefitTypeId', 'validFrom', 'validTo'],
)
@Check('chk_benefit_form_version', '`version_no` >= 1')
@Check(
  'chk_benefit_form_dates',
  '`valid_to` IS NULL OR `valid_to` >= `valid_from`',
)
@Check('chk_benefit_form_json', 'JSON_VALID(`schema_json`)')

export class BenefitFormVersion {
    @PrimaryGeneratedColumn({
  name: 'form_version_id',
  type: 'bigint',
  unsigned: true,
})
formVersionId: string;

@Column({
  name: 'benefit_type_id',
  type: 'bigint',
  unsigned: true,
})
benefitTypeId: string;

@ManyToOne(() => BenefitType, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'benefit_type_id',
  referencedColumnName: 'benefitTypeId',
})
benefitType: BenefitType;

@Column({
  name: 'version_no',
  type: 'int',
  unsigned: true,
  default: 1,
})
versionNo: number;

@Column({
  name: 'schema_json',
  type: 'longtext',
})
schemaJson: string;

@Column({
  name: 'valid_from',
  type: 'date',
})
validFrom: string;

@Column({
  name: 'valid_to',
  type: 'date',
  nullable: true,
})
validTo: string | null;

@Column({
  name: 'is_active',
  type: 'boolean',
  default: true,
})
isActive: boolean;

@Column({
  name: 'created_by',
  type: 'bigint',
  unsigned: true,
  nullable: true,
})
createdBy: string | null;

@CreateDateColumn({
  name: 'created_at',
  type: 'datetime',
})
createdAt: Date;

@ManyToOne(() => User, {
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
})
@JoinColumn({
  name: 'created_by',
  referencedColumnName: 'userId',
})
createdByUser: User | null;
}