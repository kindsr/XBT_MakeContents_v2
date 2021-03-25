unit uQuery;

interface

const
  SEL_TABLENAMES = 'select table_name from all_tables where owner = :user_id order by table_name';
  SEL_ONEROW = 'select * from :table_name where rownum = 1';
  SEL_TOOLTIP = 'SELECT ID, SEQ, CONTENT FROM XBT_MCT_TOOLTIP WHERE TO_NUMBER(ID) BETWEEN :fromnum AND :tonum ORDER BY ID';

implementation

end.
