# Tag gridRecordListPgNav

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag gridRecordListPgNav

       The gridRecordListPgNav tag/component is a built-in page navigator for gridRecordList tag.

Inheritance

       The gridRecordList has all the characteristics of the layout tag.
       See also:

                                 ○ Tag layout
                                 ○ Characteristics of all visual tags.

Characteristics

       In addition to the inherited features, gridRecordListPvNav also has the following features:

Properties and attributes

Attribute                  Type           Default  Description
                                          value

target                     GridRecordLis  nil      The gridRecordList that this
                                                   page navigator must
                           t object                control.

                                                   Remarks:

                                                             ● In a Lua form,
                                                                  specify the
                                                                  name of the
                                                                  gridRecordList.
                                                                                             ● This navigator
                                                                                                  only works if the
                                                                                                  gridRecordList
                                                                                                  paging attribute
                                                                                                  is true.

Examples:

  Goto https://sdk3.firecast.app/examples/gridRecordListPgNav/ to see examples of the
  gridRecordListPgNav.
```
