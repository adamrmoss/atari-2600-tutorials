import { getCommandLineOptions, showHelp } from './base-command-line-options';

import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name, expression, length, dataSize } = options;

if (help || !expression || !name)
{
    showHelp(usageSections);
}
else
{
    console.log(`Generating: ${expression} as ${dataSize}s for 0 ≤ t < ${length}!`);
}
