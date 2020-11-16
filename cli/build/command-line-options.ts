import { IBaseCommandLineOptions } from '../base-command-line-options';
import { ansiLogo } from '../logo';

export interface ICommandLineOptions extends IBaseCommandLineOptions
{
    verbose: boolean;
    run: boolean;
}

export const optionsDefinitions =
    [
        {
            name: 'help',
            alias: 'h',
            description: 'Display this usage guide?\nDefault Value: [bold italic]{false}',
            type: Boolean,
            defaultValue: false
        },
        {
            name: 'verbose',
            alias: 'v',
            description: 'Show verbose build?\nDefault Value: [bold italic]{false}',
            type: Boolean,
            defaultValue: false
        },
        {
            name: 'run',
            alias: 'r',
            description: 'Run game in Stella after building?\nDefault Value: [bold italic]{false}',
            type: Boolean,
            defaultValue: false
        },
        {
            name: 'name',
            description: '[bold italic]{Required} The name portion of both the assembly source and binary output',
            type: String,
            defaultOption: true
        }
    ];

export const usageSections =
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
