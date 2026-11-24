import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { User } from './entities/user.entity.js';
import { Role } from './entities/role.entity.js';
import { UserRole } from './entities/user-roles.entity.js';
import { AccountInvitation } from './entities/account_invitation.entity.js';

@Module({
    imports: [
        TypeOrmModule.forFeature([
            User,
            Role,
            UserRole,
            AccountInvitation,
        ]),
    ],
})
export class UsersModule {}