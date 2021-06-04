from robot.libraries.BuiltIn import BuiltIn

class Homework:
    builtin_lib: BuiltIn = BuiltIn()

    def Get_multiple_selection_result(self, amount):
        """
        Функция возвращается данные обо всех товарах из таблицы products,
        запас которых на складе меньше заданного параметра
        :param amount: Значение, с которым сравнивает запас товара на складе
        :return: Все подходящие товары, представленные в виде {ID товара, название товара}
        """
        sql = """SELECT DISTINCT prod.prod_id, title 
                  FROM bootcamp.inventory AS inv 
                  INNER JOIN bootcamp.products AS prod 
                  ON inv.prod_id=prod.prod_id 
                  WHERE "quan_in_stock" < %(amount)s"""
        params = {"amount": amount}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)

    def Insert_row_into_table(self, category, category_name):
        """
        Функция добавляет в таблицу categories новый ряд со значениями, переданными в параметрах
        :param category: Номер добавляемой категории. В таблице явлеяется ключом, поэтому возможно ошибка при добавлении
        :param category_name: Название новой категории. Ключом не является.
        :return: Список номеров всех категорий.
        """
        sql = """INSERT INTO bootcamp.categories (category, categoryname) 
                 VALUES (%(category)s, %(name)s);
                 SELECT category FROM bootcamp.categories"""
        params = {"category": category, "name": category_name}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)

    def Get_table_size(self):
        """
        Функция вычисляет число категорий.
        :return: Число строк в таблице categories.
        """
        sql = """SELECT COUNT(*) FROM bootcamp.categories"""
        temp = self.get_postgresql_lib().execute_sql_string_mapped(sql)
        temp2 = temp[0]['count']
        return temp2

    def Compare_sizes_before_and_after_changes(self, pre_size : int, post_size : int, insertions : int):
        """
        Функция выполняет сравнение размера таблицы до и после изменений
        :param pre_size: Размер таблицы до внесения новых строк.
        :param post_size: Размер таблицы после внесения новых строк.
        :param insertions: Число успешных операций добавления строки между замерами размера.
        :return: Истина, если значения соответствуют ожиданиям. Ложь, если значения не соответствуют ожиданиям.
        """
        return (pre_size + insertions) == post_size

    def get_postgresql_lib(self):
        """
        Служебная функция для связи с базой данных.
        :return: Ссылка на базу данных.
        """
        return self.builtin_lib.get_library_instance("DB")