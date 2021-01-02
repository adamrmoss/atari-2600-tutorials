import commandLineArgs, { OptionDefinition } from 'command-line-args';
import commandLineUsage, { Section } from 'command-line-usage';

import { libPath, dataPath, srcPath } from './paths';

export interface IBaseCommandLineOptions 
{
    help: boolean;
    name: string;
}

export function getCommandLineOptions<TCommandLineOptions extends IBaseCommandLineOptions>(
    optionsDefinitions: OptionDefinition[]
): TCommandLineOptions
{
    const commandLineOptions = (commandLineArgs(optionsDefinitions) as TCommandLineOptions);
    normalizeName(commandLineOptions);

    return commandLineOptions;
}

function normalizeName(commandLineOptions: IBaseCommandLineOptions)
{
    if (!commandLineOptions.name)
    {
        return;
    }

    commandLineOptions.name = commandLineOptions.name
        .replace(`${srcPath}/`, '')
        .replace(`${dataPath}/`, '')
        .replace(`${libPath}/`, '')
        .replace('.asm', '')
        .replace('.bin', '');
}

export function showHelp(usageSections: Section[]): void
{
    const usage = getCommandLineUsage(usageSections);
    console.log(usage);
}

export function getCommandLineUsage(usageSections: Section[]): string
{
    return commandLineUsage(usageSections);
}
