1. Abra o arquivo ENVIRONMENT.REG e edite-o para que a vari�vel ZTOFRAMEWORKROOT aponte para o caminho correto
2. Execute os arquivos LIBRARY.REG e ENVIRONMENT.REG

   $(ZTOFRAMEWORK)\BIN\DCU               --> Arquivos-fonte compilados do FW
   $(ZTOWIZARDS)\FORMTEMPLATES\BIN\DCU   --> Arquivos-fonte compilados do componente de templates de formul�rio
   $(ZTOWIZARDS)\FORMTEMPLATES\RES       --> Arquivo de recurso compartilhado pelos templates de formul�rio
   $(ZTOCOMPONENTS)\STANDARD\BIN\DCU     --> Arquivos-fonte compilados dos componentes standard;
   $(ZTOCOMPONENTS)\DATACONTROLS\BIN\DCU --> Arquivos-fonte compilados dos componentes datacontrol

Realize este procedimento *antes* de instalar qualquer componente

