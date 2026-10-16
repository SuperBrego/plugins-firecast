# Tag gridRecordList

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Tag gridRecordList

       The gridRecordList tag/component is a list of records in the interface. Used in conjunction with
       a NodeDatabase, the control presents a panel in the interface for each child node of a field.

       Remarks:

                                 ○ The item panel that is shown for each node is customized by the
                                      programmer.

                                 ○ The item panel must be a form (see Tag form) and is called the Template
                                      Form.

                                 ○ You will need at least two files with the ".lfm" extension: One containing
                                      the "gridRecordList", and another representing the item panel.

                                 ○ Each item has its own node object, and each item panel is automatically
                                      bound to its data scope.

       Key differences from recordList tag:
                           ○ gridRecordList is built to be used with The Grid System. To work
                                properly, both the gridRecordList and the templateForm must use the

                                grid system organization.
                           ○ gridRecordList does not have a built-in scrollBox. You need to provide

                                your own scrollBox tag in the lua form containing the `gridRecordList`

                                somehow.
                           ○ gridRecordList has features for filtering the items.
                           ○ gridRecordList has features for paging the items.
                           ○ gridRecordList has features for grouping the items.

Inheritance

       The gridRecordList has all the characteristics of the layout tag.
       See also:

                                 ○ Tag layout
                                 ○ Characteristics of all visual tags.

Characteristics

       In addition to the inherited features, gridRecordList also has the following features:

Properties and attributes

Attribute                  Type    Default  Description
                                   value

field                      String  <empty   The path of a field in
                                   string>  NodeDatabase.

                                            When associated, the
                                            gridRecordList starts using
                                            this field to save and display
                                            the items in this list.

                                            Comments:

                                                      ● This field must
                                                           be informed for
                                                           the
                                                           gridRecordList
                                                           to work.

                                                      ● The informed
                                                           field will become
                                                           a node in the
                                                           `NodeDatabase`.

                                            See also:

                                                      ● Lua Form and
templateForm  String       <empty                     NodeDatabase
                           string>               ● NodeDatabase
minQt         Integer
selectable    Boolean      0           Identifies the gridRecordList
selectedNode  Node object  False       template form, that is, the
                           << none >>  panel that will be displayed
selectedForm  Form object              for each item.
                           << none >>
                                       It must be equal to the
                                       "name" attribute of a form
                                       contained in some ".lfm" file
                                       of the plugin project.

                                       Yes, you will need another
                                       ".lfm" file to define to make
                                       this tag work.

                                       Defines the minimum
                                       number of items that this
                                       gridRecordList must present
                                       in the interface.

                                       Try setting the value 1 to this
                                       property. Sometimes this
                                       helps the user =)

                                       Determines whether the
                                       gridRecordList should
                                       visually function as a list of
                                       selectable items.

                                       Contains the Node object
                                       that is currently
                                       focused/selected in the
                                       gridRecordList.

                                       If there is no selection, it
                                       contains nil.

                                       When assigning a value, if
                                       the informed node object is
                                       not a child of the node
                                       informed in the attribute
                                       "field", the selection will be
                                       undone, and "selectedNode"
                                       will become nil.

                                       (Read-Only) Contains the
                                       Form object of the currently
                                       focused/selected item in the
paging        Boolean        False       gridRecordList.
pageSize      Integer        20
                             0           If there is no selection, it
pageIndex     Integer        << none >>  contains nil.
pageCount     Integer
                             {}          Define if the paging feature
filterFields  Array of                   is enabled.
              string
                                         When "paging" == true,
                                         specifies the maximum item
                                         count that can be displayed
                                         per page.

                                         When "paging" == true,
                                         specified the current page
                                         index. 0 is the first page.

                                         (Read-Only) When "paging"
                                         == true, contains the number
                                         of pages that exist in the
                                         gridRecordList.

                                         When "paging" == false, it
                                         always contains the number
                                         1.

                                         An array containing the
                                         names of fields that item
                                         nodes have.

                                         The gridRecordList monitors
                                         these fields for changes and
                                         automatically triggers the
                                         filter, group, and sort
                                         processes in response to
                                         such events.

Methods                      Description
   Method
   gridRecordList:append();  Inserts a new item into the gridRecordList.
                             Retorno:

                                       ● Returns the new Node object of the
                                            inserted item if the insertion is
                                            successful, otherwise returns nil.
gridRecordList:reorganize();     Forces the gridRecordList to re-execute the
                                 process of filtering, grouping, and sorting its
gridRecordList:scrollToNode(nod  items.
e)
                                 Scrolls through the interface's scrollBoxes so
                                 that the item's panel is visible on the screen for
                                 the user.

                                 Arguments:

                                           ● node - A Node object identifying
                                                the node of the item you want to
                                                make visible on the user's screen.

Events            Description
   Event
   onSelect       This event is triggered when the selection of the recordList
                  changes, that is, when an item is selected or when no item is
   onItemAdded    selected.

   onItemRemoved  Remarks:

                            ● To determine which item was selected, use the
                                 selectedNode and selectedForm properties.

                            ● This event is fired even when the "selectable"
                                 property is false.

                  Event triggered when a Node object is added to the
                  gridRecordList.

                  Arguments:

                                                 ○ node - The Node object that
                                                      was added.

                  Remarks:

                            ● This event represents an item that has been
                                 enumerated in the list and not necessarily that
                                 a new item has been created in the saved data.
                                 During data loading, for example, this event is
                                 triggered for each loaded item.

                  Event triggered when an item is removed from the
                  gridRecordList.

                  Arguments:

                                                 ○ node - The Node object that
                                                      was removed.
onItemFiltered       Remarks:
onItemUnfiltered
onItemShow                     ● This event represents an item that is no longer
onItemHide                          enumerated in the list and not necessarily that
onPagingStateChange                 an item has been deleted from the saved data.

                     Event triggered when an item is filtered and can be
                     displayed in the gridRecordList.

                     Arguments:

                                                    ○ node - The Node object that
                                                         was filtered.

                     Event triggered when an item is no longer filtered and
                     cannot be displayed in the gridRecordList anymore.

                     Arguments:

                                                    ○ node - The Node object that is
                                                         no longer filtered.

                     Event triggered when an item becomes visible in the
                     gridRecordList.

                     Arguments:

                                                    ○ node - The Node object that is
                                                         now visible.

                                                    ○ form - The Form object of the
                                                         item that is now visible.

                     Event triggered when an item is no longer visible in the
                     gridRecordList.

                     Arguments:

                                                    ○ node - The Node object that is
                                                         no longer visible.

                                                    ○ form - The Form object of the
                                                         item that is no longer visible

                     This event is triggered when some of the paging fields of
                     the gridRecordList have changed. The paging fields are:
                     "paging", "pageSize", "pageIndex", and "pageCount".
onCompare     This event is triggered at key moments to ensure the
onFilter      sorting of items displayed in the interface. When triggered,
onEmptyState  the event receives 2 nodes for the programmer to return,
              between the two, which should appear first.

              Arguments:

                                             ○ left - Node object containing a
                                                  node to be compared.

                                             ○ right - Node object containing
                                                  the other node to be compared.

              Return:

                                             ○ Return a number less than 0 if
                                                  "left" should be displayed
                                                  before "right"

                                             ○ Return a number greater than
                                                  0 if "left" should be displayed
                                                  after "right"

                                             ○ Return 0 if the two are
                                                  equivalent in terms of order.

              The event is triggered so the programmer can determine if
              a node is filtered and can be displayed in the
              gridRecordList.

              Arguments:

                                             ○ node - The Node object that is
                                                  being queried.

              Return:

                                             ○ Return true if the node can be
                                                  displayed in the gridRecordList
                                                  or false otherwise.

              This event is triggered when no items can be displayed on
              the gridRecordList.

              The programmer can customize the appearance of the
              gridRecordList when it is in an empty state.

              Return:

                                             ○ A visual control instance that
                                                  the gridRecordList must use as
                                                  empty state information.
onGroupId       The event is triggered for each item in the gridRecordList
onGroupCompare  so the programmer can assign groups to them.

                Arguments:

                                               ○ node - The Node object that is
                                                    being queried.

                Return:

                                               ○ A string containing the
                                                    identification of the group the
                                                    node belongs to.

                Remarks:

                          ● If this event is not handled or the programmer
                               does not return a string as a result, the node
                               will be assigned to the group identified by ""
                               (empty string).

                This event is triggered when the gridRecordList determines
                the order of item groups. When triggered, the event
                receives 2 identification strings for the programmer to
                return, between the two, which should appear first.

                Arguments:

                                               ○ left - A string, the identification
                                                    of a group;

                                               ○ right - A string, the
                                                    identification of the other
                                                    group to be compared.

                Return:

                                               ○ Return a number less than 0 if
                                                    "left" should be displayed
                                                    before "right"

                                               ○ Return a number greater than
                                                    0 if "left" should be displayed
                                                    after "right"

                                               ○ Return 0 if the two are
                                                    equivalent in terms of order.

                Remarks:

                          ● "left" and "right" are values determined by the
                               onGroupId event.
onGroupHeader        This event is triggered so the programmer can provide a
onGroupShow          control that must be used as a visual group header for the
onGroupHide          items in the group.
onBeginOrganization
                     Arguments:

                                                    ○ id - A string, the identification
                                                         of the group;

                     Returns:

                                                    ○ A visual control instance that
                                                         the gridRecordList must use as
                                                         the group header.

                     Event triggered when a group header becomes visible in
                     the gridRecordList.

                     Arguments:

                                                    ○ id - A string, the identification
                                                         of the group that became
                                                         visible.

                                                    ○ header - The visual control
                                                         instance of the header that is
                                                         now visible.

                     Event triggered when a group header is no longer visible in
                     the gridRecordList.

                     Arguments:

                                                    ○ id - A string, the identification
                                                         of the group that is no longer
                                                         visible.

                                                    ○ header - The visual control
                                                         instance of the header that is
                                                         no longer visible

                     Event triggered when the gridRecordList starts the
                     organization of its items

                     After this event, the gridRecordList may trigger multiple
                     calls to the following events:

                               ● onItemAdded/onItemRemoved
                               ● onItemFiltered/onItemUnfiltered
                               ● onItemShow/onItemHide
                               ● onPagingStateChange
                               ● onCompare
                               ● onFilter
                               ● onEmptyState
                               ● onGroupId
                                          ● onGroupCompare
                                          ● onGroupHeader
                                          ● onGroupShow/onGroupHide

onEndOrganization                Event triggered when the gridRecordList finishes the
                                 organization of its items and it will not trigger more of the
                                 events listed in the "onBeginOrganization" event until the
                                 next trigger to the event "onBeginOrganization".

See Handling Lua Form events

Examples:

  Goto https://sdk3.firecast.app/examples/gridRecordList/ to see examples of the gridRecordList
```
