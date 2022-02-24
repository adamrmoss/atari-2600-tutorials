export enum DataSize
{
    byte = 'byte',
    word = 'word',
}

export default DataSize;

export function getLengthInBytes(dataSize: DataSize): 1 | 2
{
    switch (dataSize)
    {
        case DataSize.byte:
            return 1;
        case DataSize.word:
            return 2;
    }
}

export function getDataByte(value: number, byteIndex: 0 | 1): number
{
    switch (byteIndex)
    {
        case 0:
            return value % 0x100;
        case 1:
            return value / 0x100;
    }
}
