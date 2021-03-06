with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size: Integer := 50000;
   type my_arr is array(0..size-1) of Long_Integer;
   arr: my_arr;

   function elements_sum (first_element_indx: Integer; second_element_indx: Integer) return Long_Integer;

   task type part_sum is
      entry start(first_element_indx: Integer; second_element_indx: Integer);
   end part_sum;

   task body part_sum is
      first_indx, second_indx : Integer;
   begin
      accept start(first_element_indx: Integer; second_element_indx: Integer) do
         first_indx := first_element_indx;
         second_indx := second_element_indx;
      end start;

      arr(first_indx) := elements_sum(first_indx, second_indx);

      arr(second_indx) := 0;

   end part_sum;

   function elements_sum (first_element_indx: Integer; second_element_indx: Integer) return Long_Integer is
   begin
      return arr(first_element_indx) + arr(second_element_indx);
   end elements_sum;


   type part_sum_thread is access part_sum;

   sum_thread_arr : array (0..size/2) of part_sum_thread;
   active_size: Integer := size;
   last_size: Integer := size;
begin
   for i in 0..size-1 loop
      arr(i) := long_integer(i);
   end loop;

   while active_size > 1 loop
      if active_size rem 2 = 0 then
         active_size := active_size / 2;
      else
         active_size := active_size / 2 + 1;
      end if;

      for i in 0..active_size-1 loop
         if i /= last_size - i - 1 then
            sum_thread_arr(i) := new part_sum;
            sum_thread_arr(i).start(i, last_size - i - 1);
         end if;
      end loop;

      last_size := active_size;
   end loop;

   Put_Line(arr(0)'Img);
end Main;


