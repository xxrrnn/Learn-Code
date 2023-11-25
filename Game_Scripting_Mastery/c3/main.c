#include <stdio.h>
#include <conio.h> 
#define COMMAND_PRINTSTRING         "PrintString"
#define COMMAND_PRINTSTRINGLOOP      "PringStringLoop"
#define COMMAND_NEWLINE             "Newline"
#define COMMAND_WAITFORKEYPRESS     "WaitForKeyPress"
#define MAX_COMMAND_SIZE             64
#define MAX_PARAM_SIZE              1024
#define MAX_SOURCE_LINE_SIZE        4096

int g_iScriptSize = 0;
char** g_ppstrScript ;
int g_iCurrScriptLineChar = 0;
int g_iCurrScriptLine = 0;
void LoadScript(char * pstrFilename)
{
    FILE * pScriptFile;

    if(!(pScriptFile = fopen(pstrFilename,"rb")))
    {
        printf("FILE I/O error. \n");
        exit (0);
    }

    while( ~feof(pScriptFile)) //在C语言中，feof 是一个用于文件处理的标准库函数，它用来检查文件流的结束标志。feof 函数通常用于循环读取文件，以判断是否已经读取到文件的末尾。
    {
        if( fgetc(pScriptFile) == '\n')
            ++ g_iScriptSize;
    }
    ++ g_iScriptSize;
    fclose(pScriptFile);
    if( ! (pScriptFile = fopen(pstrFilename, "r")))
    {
        printf("File I/O error. \n");
        exit (0);
    }
    g_ppstrScript = (char**) malloc (g_iScriptSize * sizeof(char *));
    for(int iCurrLineIndex = 0; iCurrLineIndex < g_iScriptSize; ++ iCurrLineIndex)
    {
        g_ppstrScript[ iCurrLineIndex] = (char*)malloc(MAX_SOURCE_LINE_SIZE + 1);
        fgets(g_ppstrScript[iCurrLineIndex], MAX_SOURCE_LINE_SIZE,pScriptFile); //fgets 是C语言中标准库中用于从文件或输入流中读取一行文本的函数。它通常用于读取文本文件的内容，一次一行，包括换行符 \n 在内。
    }
}
void UnloadScript()
{
    if(!g_ppstrScript)
        return;
    for(int iCurrLineIndex = 0; iCurrLineIndex < g_iScriptSize; ++iCurrLineIndex)
        free(g_ppstrScript[iCurrLineIndex]);
    free(g_ppstrScript);
}

void RunScript()
{
    char pstrCommand [MAX_COMMAND_SIZE];
    char pstrStringParam [MAX_PARAM_SIZE];
    for(g_iCurrScriptLine = 0; g_iCurrScriptLine < g_iScriptSize; ++g_iCurrScriptLine)
    {
        g_iCurrScriptLineChar = 0;
        GetCommand(pstrCommand);

        if(stricmp(pstrCommand, COMMAND_PRINTSTRING) == 0)
        {
            GetStringParam(pstrStringParam);
            printf("\t%s\n",pstrStringParam);
        }
        else if(stricmp(pstrCommand, COMMAND_PRINTSTRINGLOOP) == 0)
        {
            GetStringParam(pstrStringParam);
            int iLoopCount = GetIntParam();
            for(int iCurrString = 0; iCurrString < iLoopCount; ++iCurrString)
                printf("\t%d:%s\n",iCurrString,pstrStringParam);
        }
        else if(stricmp(pstrCommand, COMMAND_NEWLINE) == 0)
        {
            print("\n");
        }
        else if(stricmp(pstrCommand, COMMAND_WAITFORKEYPRESS) == 0)
        {
            while(kbhit())
                getch();
            while(~knhit());
        }
        else
        {
            printf("\tError: Invalid command.\n");
            break;
        }
    }

}

void GetCommand(char * pstrDestString)
{
    int iCommandSize = 0;
    char cCurrChar;
    while(g_iCurrScriptLineChar < (int)strlen(g_ppstrScript[g_iCurrScriptLine]))
    {
        cCurrChar = g_ppstrScript[g_iCurrScriptLine][g_iCurrScriptLineChar];
        if(cCurrChar == ' ' || cCurrChar == '\n')
            break;
        pstrDestString[iCommandSize] = cCurrChar;
        ++iCommandSize;
        ++g_iCurrScriptLineChar;
    }
    ++g_iCurrScriptLineChar;
    pstrDestString[iCommandSize] = '\0';
    strupr(pstrDestString);

}

int main(void) {
  printf("Hello World!");
  return 0;
}