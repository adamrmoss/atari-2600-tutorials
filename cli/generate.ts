import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name, expression, min, max, dataSize } = options;

if (help || !expression || !name)
{
    showHelp(usageSections);
} else if (min > max) {
    console.error('Error: min > max');
} else
{
    console.log(`Generating: ${expression} as ${dataSize}s between ${min} and ${max}!`);
}
