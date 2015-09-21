if([select count() from user where username like 'deploy.system@unilever.com%' and isactive=true]==0) {
    User u = [select id, isactive, username from user where username like 'deploy.system@unilever.com%' limit 1][0];
    u.isactive = true;
    update u;
}