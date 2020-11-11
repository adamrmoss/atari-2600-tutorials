
import { IBaseCommandLineOptions } from '../base-command-line-options';
import { ansiLogo } from '../logo';

import { DataSize } from './data-size';

export interface ICommandLineOptions extends IBaseCommandLineOptions
{
    expression: string;
    min: number;
    max: number;
    dataSize: DataSize;
}

export const optionsDefinitions =
    [
        {
            name: 'help',
            alias: 'h',
            description: 'Display this usage guide?',
            type: Boolean,
            default: false
        },
        {
            name: 'expression',
            alias: 'e',
            description: '[bold italic]{Required} The [bold]{JS} expression to be evaluated',
            type: String,
            default: false
        },
        {
            name: 'min',
            alias: 'n',
            description: '[bold italic]{Required} Minimum index of table',
            type: Number,
            default: false
        },
        {
            name: 'max',
            alias: 'x',
            description: '[bold italic]{Required} Maximum index of table',
            type: Number,
            default: false
        },
        {
            name: 'name',
            description: '[bold italic]{Required} The name portion of the assembly or binary output',
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
            header: 'atari-2600-tutorials/generate.js',
            content: 'Generate binary data for [bold]{Atari 2600} games'
        },
        {
            header: 'Synopsis',
            content: '$ generate <options> [bold italic]{name}'
        },
        {
            header: 'Options',
            optionList: optionsDefinitions
        }
    ];
