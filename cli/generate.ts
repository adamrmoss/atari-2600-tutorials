import { getCommandLineOptions, showHelp } from './base-command-line-options';
import { ICommandLineOptions, optionsDefinitions, usageSections } from './generate/command-line-options';

const options = getCommandLineOptions<ICommandLineOptions>(optionsDefinitions);
const { help, name } = options;

if (help || !name)
{
    showHelp(usageSections);
} else
{
    console.log('Generating!');
}
