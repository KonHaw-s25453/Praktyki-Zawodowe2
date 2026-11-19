import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('document_types')
@Index('uq_document_types_code', ['documentCode'], { unique: true })
@Index('idx_document_types_name', ['documentName'])
export class DocumentType {
  @PrimaryGeneratedColumn({
    name: 'document_type_id',
    type: 'bigint',
    unsigned: true,
  })
  documentTypeId: string;

  @Column({
    name: 'document_code',
    type: 'varchar',
    length: 50,
  })
  documentCode: string;

  @Column({
    name: 'document_name',
    type: 'varchar',
    length: 150,
  })
  documentName: string;

  @Column({
    name: 'description',
    type: 'text',
    nullable: true,
  })
  description: string | null;

  @Column({
    name: 'is_active',
    type: 'tinyint',
    default: 1,
  })
  isActive: boolean;

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
}