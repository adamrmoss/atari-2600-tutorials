
import commandLineArgs from 'command-line-args';
import commandLineUsage from 'command-line-usage';

import { ansiLogo } from './logo';

export interface ICommandLineOptions 
{
    help: boolean;
    srcPath: string;
    romPath: string;
    name: string;
}

export function getCommandLineOptions()
{
    return commandLineArgs(optionsDefinitions) as ICommandLineOptions;
}

export function getCommandLineUsage()
{
    return commandLineUsage(usageSections);
}

const optionsDefinitions =
    [
        {
            name: 'help', alias: 'h',
            description: 'Display this usage guide',
            type: Boolean
        },
        {
            name: 'srcPath', alias: 's',
            description: '[bold italic]{Optional} Assembly source directory, defaults to this directory',
            type: String,
            defaultValue: '.'
        },
        {
            name: 'romPath', alias: 'r',
            description: '[bold italic]{Optional} Roms directory to copy binary output to',
            type: String
        },
        {
            name: 'name',
            description: '[bold italic]{Required} The name portion of both the assembly source and binary output',
            type: String,
            defaultOption: true
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
