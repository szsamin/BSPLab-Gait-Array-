function [USER] = UserSpecify

choice = menu('Select a user','Erich','Shadman','Wan','Tanisha','John');

switch choice
    case 1
        USER = 'Erich';
    case 2
        USER = 'Shadman';
    case 3
        USER = 'Wan';
    case 4
        USER = 'Tanisha';
    case 5
        USER = 'John';
end

end