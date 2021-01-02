import { execSync } from 'child_process';
import exit from 'exit';

export default function shell(command: string): void
{
    try 
    {
        execSync(command, { stdio: 'inherit' });
    }
    catch 
    {
        exit(1);
    }
}
