import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  Check
} from 'typeorm';

import { BenefitType } from './benefit-type.entity.js';
import { DocumentType } from '../../documents/entities/document_type.entity.js';

@Entity('benefit_required_documents')
@Index(
  'uq_benefit_document_version',
  ['benefitTypeId', 'documentTypeId', 'versionNo'],
  { unique: true },
)
@Index('idx_benefit_required_documents_document', ['documentTypeId'])
@Index(
  'idx_benefit_required_documents_dates',
  ['validFrom', 'validTo'],
)
@Check('chk_benefit_document_version', '`version_no` >= 1')
@Check(
  'chk_benefit_document_dates',
  '`valid_to` IS NULL OR `valid_to` >= `valid_from`',
)
export class BenefitRequiredDocument {
@PrimaryGeneratedColumn({
  name: 'requirement_id',
  type: 'bigint',
  unsigned: true,
})
requirementId: string;

@Column({
  name: 'benefit_type_id',
  type: 'bigint',
  unsigned: true,
})
benefitTypeId: string;

@Column({
  name: 'document_type_id',
  type: 'bigint',
  unsigned: true,
})
documentTypeId: string;

@ManyToOne(() => BenefitType, {
  onUpdate: 'RESTRICT',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'benefit_type_id',
  referencedColumnName: 'benefitTypeId',
})
benefitType: BenefitType;

@ManyToOne(() => DocumentType, {
  onUpdate: 'RESTRICT',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'document_type_id',
  referencedColumnName: 'documentTypeId',
})
documentType: DocumentType;

@Column({
  name: 'version_no',
  type: 'int',
  unsigned: true,
  default: 1,
})
versionNo: number;

@Column({
  name: 'is_required',
  type: 'boolean',
  default: true,
})
isRequired: boolean;

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
  name: 'instructions',
  type: 'text',
  nullable: true,
})
instructions: string | null;

@CreateDateColumn({
  name: 'created_at',
  type: 'datetime',
})
createdAt: Date;
}