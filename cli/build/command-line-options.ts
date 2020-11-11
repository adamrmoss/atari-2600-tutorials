
import commandLineArgs, { OptionDefinition } from 'command-line-args';
import commandLineUsage from 'command-line-usage';

import { ansiLogo } from '../logo';
import { srcPath } from '../paths';

export interface ICommandLineOptions 
{
    help: boolean;
    verbose: boolean;
    name: string;
    run: boolean;
}

export function getCommandLineOptions()
{
    const commandLineOptions = (commandLineArgs(optionsDefinitions) as ICommandLineOptions);
    normalizeName(commandLineOptions);

    return commandLineOptions;
}

function normalizeName(commandLineOptions: ICommandLineOptions)
{
    if (!commandLineOptions.name)
    {
        return;
    }

    commandLineOptions.name = commandLineOptions.name
        .replace(`${srcPath}/`, '')
        .replace('.asm', '');
}

export function getCommandLineUsage()
{
    return commandLineUsage(usageSections);
}

const optionsDefinitions =
    [
        {
            name: 'help',
            alias: 'h',
            description: 'Display this usage guide?',
            type: Boolean,
            default: false
        },
        {
            name: 'verbose',
            alias: 'v',
            description: 'Show verbose build?',
            type: Boolean,
            default: false
        },
        {
            name: 'name',
            description: '[bold italic]{Required} The name portion of both the assembly source and binary output',
            type: String,
            defaultOption: true
        },
        {
            name: 'run',
            alias: 'r',
            description: 'Run game in Stella after building?',
            type: Boolean,
            default: false
        }
    ];

const usageSections =
    [
        {
            content: ansiLogo,
            raw: true
        },
        {
            header: 'atari-2600-tutorials/build.js',
            content: 'Compile [bold]{Atari 2600} games using [bold]{dasm}'
        },
        {
            header: 'Synopsis',
            content: '$ build <options> [bold italic]{name}'
        },
        {
            header: 'Options',
            optionList: optionsDefinitions
        }
    ];

export function showHelp()
{
    const usage = getCommandLineUsage();
    console.log(usage);
}
