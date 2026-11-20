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

import { Application } from '../applications/application.entity.js';
import { BenefitRequiredDocument } from '../benefit_required_documents/benefit_required_document.entity.js';
import { User } from '../users/user.entity.js';

@Entity('application_documents')

@Index(
  'uq_application_document_requirement',
  ['applicationId', 'requirementId'],
  { unique: true },
)

@Index('idx_application_documents_status', ['documentStatus'])
@Index('idx_application_documents_recorder', ['recordedBy'])
@Index('idx_application_documents_verifier', ['verifiedBy'])

@Check(
  'chk_application_document_status',
  "`document_status` IN ('NOT_REQUIRED','PENDING','DELIVERED','VERIFIED')",
)

export class ApplicationDocument {
    @PrimaryGeneratedColumn({
  name: 'application_document_id',
  type: 'bigint',
  unsigned: true,
})
applicationDocumentId: string;

@Column({ name: 'application_id', type: 'bigint', unsigned: true })
applicationId: string;

@ManyToOne(() => Application, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'application_id',
  referencedColumnName: 'applicationId',
})
application: Application;

@Column({ name: 'requirement_id', type: 'bigint', unsigned: true })
requirementId: string;

@ManyToOne(() => BenefitRequiredDocument, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({
  name: 'requirement_id',
  referencedColumnName: 'requirementId',
})
requirement: BenefitRequiredDocument;

@Column({ name: 'recorded_by', type: 'bigint', unsigned: true, nullable: true })
recordedBy: string | null;

@Column({ name: 'verified_by', type: 'bigint', unsigned: true, nullable: true })
verifiedBy: string | null;

@ManyToOne(() => User, {
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
  nullable: true,
})
@JoinColumn({ name: 'recorded_by', referencedColumnName: 'userId' })
recordedByUser: User | null;

@ManyToOne(() => User, {
  onUpdate: 'CASCADE',
  onDelete: 'SET NULL',
  nullable: true,
})
@JoinColumn({ name: 'verified_by', referencedColumnName: 'userId' })
verifiedByUser: User | null;

@Column({ name: 'document_status', type: 'varchar', length: 20, default: 'PENDING' })
documentStatus: string;

@Column({ name: 'delivered_at', type: 'datetime', nullable: true })
deliveredAt: Date | null;

@Column({ name: 'verified_at', type: 'datetime', nullable: true })
verifiedAt: Date | null;

@Column({ name: 'notes', type: 'text', nullable: true })
notes: string | null;

@CreateDateColumn({ name: 'created_at', type: 'datetime' })
createdAt: Date;

@UpdateDateColumn({ name: 'updated_at', type: 'datetime' })
updatedAt: Date;
}

