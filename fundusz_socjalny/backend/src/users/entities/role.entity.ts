import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  Index,
} from 'typeorm';

@Entity('roles')
@Index('uq_roles_role_code', ['roleCode'], { unique: true })
export class Role {
  @PrimaryGeneratedColumn({
    name: 'role_id',
    type: 'bigint',
    unsigned: true,
  })
  roleId: string;

  @Column({
    name: 'role_code',
    type: 'varchar',
    length: 50,
  })
  roleCode: string;

  @Column({
    name: 'role_name',
    type: 'varchar',
    length: 100,
  })
  roleName: string;

  @Column({
    name: 'description',
    type: 'text',
    nullable: true,
  })
  description: string | null;
}