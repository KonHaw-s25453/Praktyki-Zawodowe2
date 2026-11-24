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

import { Application } from './application.entity.js';
import { BenefitFormVersion } from '../../benefits/entities/benefit_form_version.entity.js';
import { User } from '../../users/entities/user.entity.js';

@Entity('application_versions')
@Index(
  'uq_application_version',
  ['applicationId', 'versionNo'],
  { unique: true },
)
@Index('idx_application_versions_form', ['formVersionId'])
@Index('idx_application_versions_user', ['createdBy'])
@Check('chk_application_version_no', '`version_no` >= 1')
@Check(
  'chk_application_requested_amount',
  '`requested_amount` IS NULL OR `requested_amount` >= 0',
)
@Check('chk_application_form_json', 'JSON_VALID(`form_data`)')

export class ApplicationVersion {

@PrimaryGeneratedColumn({
  name: 'application_version_id',
  type: 'bigint',
  unsigned: true,
})
applicationVersionId: string;


@Column({ name: 'application_id', type: 'bigint', unsigned: true })
applicationId: string;

@Column({ name: 'form_version_id', type: 'bigint', unsigned: true })
formVersionId: string;

@Column({ name: 'created_by', type: 'bigint', unsigned: true })
createdBy: string;

@ManyToOne(() => Application, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({ name: 'application_id', referencedColumnName: 'applicationId' })
application: Application;

@ManyToOne(() => BenefitFormVersion, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({ name: 'form_version_id', referencedColumnName: 'formVersionId' })
formVersion: BenefitFormVersion;

@ManyToOne(() => User, {
  onUpdate: 'CASCADE',
  onDelete: 'RESTRICT',
})
@JoinColumn({ name: 'created_by', referencedColumnName: 'userId' })
createdByUser: User;

@Column({ name: 'version_no', type: 'int', unsigned: true, default: 1 })
versionNo: number;

@Column({ name: 'form_data', type: 'longtext' })
formData: string;

@Column({ name: 'requested_amount', type: 'decimal', precision: 12, scale: 2, nullable: true })
requestedAmount: string | null;

@CreateDateColumn({ name: 'created_at', type: 'datetime' })
createdAt: Date;

@Column({ name: 'submitted_at', type: 'datetime', nullable: true })
submittedAt: Date | null;
}