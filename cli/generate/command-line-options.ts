
import { IBaseCommandLineOptions } from '../base-command-line-options';
import { ansiLogo } from '../logo';

import { DataSize } from './data-size';

export interface ICommandLineOptions extends IBaseCommandLineOptions
{
    min: number;
    max: number;
    dataSize: DataSize;
    expression: string;
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
            name: 'min',
            alias: 'n',
            description: 'Inclusive inimum index of table\nDefault Value: [bold italic]{0}',
            type: Number,
            defaultValue: 0
        },
        {
            name: 'max',
            alias: 'x',
            description: 'Inclusive maximum index of table\nDefault Value: [bold italic]{255}',
            type: Number,
            defaultValue: 255
        },
        {
            name: 'dataSize',
            alias: 'd',
            description: 'Size of generated table cell: [bold italic]{byte}, [bold italic]{word}, or [bold italic]{fixed-point}\n'
                             + 'Default Value: [bold italic]{byte}',
            type: String,
            defaultValue: 'byte'
        },
        {
            name: 'expression',
            alias: 'e',
            description: '[bold italic]{Required} The [bold]{JS} expression to be evaluated',
            type: String
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
