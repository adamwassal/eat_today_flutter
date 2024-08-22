// ignore_for_file: avoid_print
import 'package:eat_today/cubit/main_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitState());
  static MainCubit get(context) => BlocProvider.of(context);

  Database? database;

  // Initialize the database and create tables
  initSql() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Table to store meal data
      await db.execute('''CREATE TABLE Meals (
          id INTEGER PRIMARY KEY, 
          img TEXT,
          name TEXT,
          time TEXT,
          isfavorite BOOLEAN,
          detail TEXT)
          ''');
    });
  }

  List<Map> list = [];
  List<Map> listbreakfast = [];
  List<Map> listlunch = [];
  List<Map> listdinner = [];

  // Fetch all meals from the database
  getData() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');
    database = await openDatabase(path);
    await database!.rawQuery('SELECT * FROM Meals').then((value) {
      list = value;
      // تحديث القوائم الفرعية بناءً على نوع الوجبة
      listbreakfast = list.where((meal) => meal['time'] == 'إفطار').toList();
      listlunch = list.where((meal) => meal['time'] == 'غداء').toList();
      listdinner = list.where((meal) => meal['time'] == 'عشاء').toList();
      emit(GetDataSuccessState());
      print('got data');
    }).catchError((onError) {
      emit(GetDataErrorState());
      print(onError.toString());
    });
  }

  // Insert initial data into the database
  void insertData() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');
    database = await openDatabase(path);

    List<Map<String, dynamic>> existingMeals =
        await database!.rawQuery('SELECT COUNT(*) as count FROM Meals');

    if (existingMeals[0]['count'] == 0) {
      List<Map<String, String>> meals = [
        // الإفطار
        {
          'img': 'assets/meals/foul.jpg',
          'name': 'فول مدمس',
          'time': 'إفطار',
          'details': 'فول، ثوم، عصير ليمون، كمون، زيت زيتون، ملح، فلفل، بقدونس'
        },
        {
          'img': 'assets/meals/taamia.jpg',
          'name': 'طعمية',
          'time': 'إفطار',
          'details':
              'حمص أو فول، بصل، ثوم، أعشاب طازجة (بقدونس، كزبرة)، كمون، كزبرة ناشفة، بيكنج باودر، ملح، فلفل'
        },
        {
          'img': 'assets/meals/eggmakly.jpg',
          'name': 'بيض مقلي',
          'time': 'إفطار',
          'details': 'بيض، خبز بلدي، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/kareesh.png',
          'name': 'جبنة قريش',
          'time': 'إفطار',
          'details': 'جبنة قريش، طماطم، خيار، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/ega.jpg',
          'name': 'عجة مصرية',
          'time': 'إفطار',
          'details': 'بيض، بصل، بقدونس، طماطم، فلفل رومي، ملح، فلفل، زيت زيتون'
        },
        {
          'img': 'assets/meals/koshry.jpg',
          'name': 'كشري شعيرية',
          'time': 'إفطار',
          'details':
              'شعيرية، عدس، أرز، حمص، صلصة طماطم، ثوم، خل، كمون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fteer.jpg',
          'name': 'فطير مشلتت',
          'time': 'إفطار',
          'details': 'دقيق، ماء، سمن (زبدة مصفاة)، عسل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'زبادي مع عسل',
          'time': 'إفطار',
          'details': 'زبادي، عسل، فواكه طازجة (مثل الموز، الفراولة، التوت)'
        },
        {
          'img': 'assets/meals/bleela.webp',
          'name': 'بليلة',
          'time': 'إفطار',
          'details': 'قمح كامل، لبن، سكر، قرفة (اختياري)، مكسرات (اختياري)'
        },
        {
          'img': 'assets/meals/batingan.jpg',
          'name': 'باذنجان مخلل',
          'time': 'إفطار',
          'details': 'باذنجان، ثوم، خل، ملح، فلفل حار، زيت'
        },
        // الغداء
        {
          'img': 'assets/meals/koshry.jpg',
          'name': 'كشري',
          'time': 'غداء',
          'details':
              'أرز، عدس، مكرونة، حمص، صلصة طماطم، ثوم، خل، كمون، بصل مقلي'
        },
        {
          'img': 'assets/meals/moologia.jpg',
          'name': 'ملوخية بالأرز',
          'time': 'غداء',
          'details': 'ملوخية، ثوم، مرق دجاج أو لحم، كزبرة، زبدة أو زيت، أرز'
        },
        {
          'img': 'assets/meals/mahshy.jpeg',
          'name': 'محشي',
          'time': 'غداء',
          'details':
              'ورق عنب، أرز، لحم مفروم (اختياري)، طماطم، بصل، بقدونس، شبت، نعناع، صلصة طماطم'
        },
        {
          'img': 'assets/meals/chicken.jpg',
          'name': 'فراخ مشوية',
          'time': 'غداء',
          'details': 'فراخ، ثوم، عصير ليمون، زيت زيتون، ملح، فلفل، بابريكا'
        },
        {
          'img': 'assets/meals/meattagen.jpg',
          'name': 'طاجن اللحمة',
          'time': 'غداء',
          'details':
              'بامية، لحم بقر أو غنم، طماطم، بصل، ثوم، كزبرة، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/meatkabsa.jpg',
          'name': 'كبسة باللحم',
          'time': 'غداء',
          'details':
              'أرز، لحم ضأن أو دجاج، طماطم، بصل، ثوم، توابل (كمون، كزبرة، هيل، قرفة، ورق غار)، زبيب، لوز'
        },
        {
          'img': 'assets/meals/bolty.jpg',
          'name': 'سمك بلطي مشوي',
          'time': 'غداء',
          'details': 'سمك بلطي، ثوم، عصير ليمون، زيت زيتون، ملح، فلفل، كمون'
        },
        {
          'img': 'assets/meals/hamam.png',
          'name': 'حمام محشي',
          'time': 'غداء',
          'details':
              'حمام، أرز، كبد، قوانص، بصل، توابل (قرفة، جوزة الطيب، بهارات مشكلة)، زبدة أو زيت'
        },
        {
          'img': 'assets/meals/akawy.jpg',
          'name': 'طاجن عكاوي',
          'time': 'غداء',
          'details':
              'عكاوي، بصل، طماطم، ثوم، قرفة، ورق غار، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'فتة باللحم',
          'time': 'غداء',
          'details':
              'عيش، أرز، لحم بقر أو غنم، زبادي، ثوم، خل، خبز، سمن أو زبدة'
        },
        // العشاء
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'شاورما',
          'time': 'عشاء',
          'details':
              'لحم بقري أو دجاج، ثوم، زبادي، عصير ليمون، خل، كمون، كزبرة، بابريكا، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'فتة شاورما',
          'time': 'عشاء',
          'details':
              'لحم شاورما (بقري أو دجاج)، أرز، زبادي، ثوم، خل، خبز، سمن أو زبدة'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'فلافل',
          'time': 'عشاء',
          'details':
              'حمص أو فول، بصل، ثوم، أعشاب طازجة (بقدونس، كزبرة)، كمون، كزبرة ناشفة، بيكنج باودر، ملح، فلفل، خبز بلدي'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'جبنة قديمة',
          'time': 'عشاء',
          'details': 'جبنة قديمة، طماطم، زيتون، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'عجة بالبصل',
          'time': 'عشاء',
          'details': 'بيض، بصل، ملح، فلفل، زيت زيتون'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'سلطة تبولة',
          'time': 'عشاء',
          'details':
              'بقدونس، طماطم، برغل، بصل، نعناع، عصير ليمون، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'سندوتشات',
          'time': 'عشاء',
          'details': 'بطاطس، ثوم، عصير ليمون، كمون، خبز، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'سمك مقلي',
          'time': 'عشاء',
          'details':
              'فيليه سمك، دقيق، بيض، بقسماط، خس، طماطم، خيار، زيت زيتون، عصير ليمون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'كبدة إسكندراني',
          'time': 'عشاء',
          'details':
              'كبدة (بقر أو دجاج)، ثوم، عصير ليمون، كمون، كزبرة، فلفل حار، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/fata.jpg',
          'name': 'بطاطس مهروسة',
          'time': 'عشاء',
          'details': 'بطاطس، لبن، زبدة، ملح، فلفل، خبز'
        },
        // إضافة الأصناف الجديدة
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سجق مدخن',
          'time': 'غداء',
          'details': 'سجق مدخن، بصل، فلفل، طماطم، توابل، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سمك مدخن',
          'time': 'غداء',
          'details': 'سمك، توابل مدخنة، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سباجيتي كاربونارا',
          'time': 'غداء',
          'details': 'سباجيتي، لحم مقدد، كريمة، جبنة بارميزان، ثوم، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'خضروات مشوية',
          'time': 'غداء',
          'details':
              'خضروات متنوعة (فلفل، كوسا، باذنجان)، زيت زيتون، ملح، فلفل، توابل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'لازانيا نباتية',
          'time': 'غداء',
          'details': 'مكرونة لازانيا، صلصة طماطم، خضروات، جبنة، زبدة، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'شوربة عدس',
          'time': 'غداء',
          'details': 'عدس، بصل، ثوم، جزر، طماطم، مرق، ملح، فلفل، زيت زيتون'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'دجاج مقلي بالصوص',
          'time': 'غداء',
          'details':
              'دجاج، صوص الصويا، خضروات (جزر، فلفل، بصل)، زيت سمسم، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'أرز حار',
          'time': 'غداء',
          'details': 'أرز، توابل حارة، بصل، ثوم، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'موساكا باذنجان',
          'time': 'غداء',
          'details': 'باذنجان، لحم مفروم، صلصة طماطم، بصل، ثوم، جبنة، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'برجر',
          'time': 'عشاء',
          'details':
              'لحم برجر، خبز، خس، طماطم، بصل، جبنة، مايونيز، كاتشب، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'تشيز كيك',
          'time': 'عشاء',
          'details': 'جبنة كريمية، بسكويت، زبدة، سكر، فانيليا'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'كاري دجاج',
          'time': 'عشاء',
          'details':
              'دجاج، صلصة كاري، جزر، بطاطس، بصل، ثوم، زيت نباتي، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'يخنة خضروات',
          'time': 'عشاء',
          'details': 'خضروات متنوعة، مرق، بصل، ثوم، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سوفليه الجبنة',
          'time': 'عشاء',
          'details': 'جبنة، بيض، حليب، دقيق، زبدة، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'بان كيك',
          'time': 'عشاء',
          'details': 'دقيق، حليب، بيض، سكر، زبدة، بيكنج باودر'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'مافن',
          'time': 'عشاء',
          'details':
              'دقيق، سكر، بيض، زبدة، فانيليا، بيكنج باودر، مكسرات (اختياري)'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سموذي فواكه',
          'time': 'عشاء',
          'details': 'فواكه متنوعة، زبادي، عسل، ثلج'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'شوربة خضروات',
          'time': 'عشاء',
          'details': 'خضروات متنوعة، مرق، بصل، ثوم، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سلطة كينوا',
          'time': 'عشاء',
          'details':
              'كينوا، طماطم، خيار، فلفل رومي، بقدونس، زيت زيتون، عصير ليمون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'ريزوتو الفطر',
          'time': 'عشاء',
          'details':
              'أرز ريزوتو، فطر، كريمة، بصل، ثوم، جبنة بارميزان، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'باستا كريمية',
          'time': 'عشاء',
          'details': 'مكرونة، كريمة، جبنة، ثوم، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'سلطة البيض',
          'time': 'عشاء',
          'details': 'بيض، مايونيز، خردل، ملح، فلفل، بصل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'دجاج محمص',
          'time': 'عشاء',
          'details': 'دجاج، زيت زيتون، توابل (روز ماري، ملح، فلفل)، ثوم'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'بطاطس حلوة مقلية',
          'time': 'عشاء',
          'details': 'بطاطس حلوة، زيت زيتون، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'كرات الجبنة',
          'time': 'عشاء',
          'details': 'جبنة، دقيق، بيض، زبدة، ملح، فلفل'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'تفاح مقرمش',
          'time': 'عشاء',
          'details': 'تفاح، دقيق، سكر، زبدة، قرفة'
        },
        {
          'img': 'assets/meals/zabady.jpg',
          'name': 'كيك الشوكولاتة',
          'time': 'عشاء',
          'details': 'دقيق، سكر، كاكاو، بيض، زبدة، حليب، بيكنج باودر'
        },
      ];

      for (var meal in meals) {
        await database!.rawInsert(
            'INSERT INTO Meals(img, name, time, isfavorite, detail) VALUES(?,?,?,?,?)',
            [
              meal['img'],
              meal['name'],
              meal['time'],
              'false',
              meal['details']
            ]).then((value) {
          if (meal['time'] == 'إفطار') {
            listbreakfast.add(meal);
          }
          if (meal['time'] == 'غداء') {
            listlunch.add(meal);
          }
          if (meal['time'] == 'عشاء') {
            listdinner.add(meal);
          }
          print('Inserted ${meal['name']} successfully');
        }).catchError((onError) {
          print('Error inserting ${meal['name']}: $onError');
        });
      }
    }
  }

  // Delete the database
  mydeleteDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'database.db');
    await deleteDatabase(path);
    print('database was deleted');
  }

  // Get a random meal based on time and day
  Map<String, dynamic>? getRandomMeal(String mealTime, [DateTime? day]) {
    List filteredMeals =
        list.where((meal) => meal['time'] == mealTime).toList();

    if (filteredMeals.isEmpty) {
      return null;
    }

    // ignore: prefer_conditional_assignment
    if (day == null) {
      day = DateTime.now();
    }

    // Use the day to generate a consistent random index
    int randomIndex = day.day % filteredMeals.length;

    return filteredMeals[randomIndex];
  }

  // Get meals for a specific day
  List<Map<String, dynamic>?> getMealsForDay(DateTime day) {
    return [
      getRandomMeal('إفطار', day),
      getRandomMeal('غداء', day),
      getRandomMeal('عشاء', day),
    ].where((meal) => meal != null).toList();
  }

  // Check if a specific day has meals
  bool hasMeals(DateTime day) {
    // For now, every day has meals
    // You might want to implement a more sophisticated system later
    return true;
  }

  updateData(bool isFavorite, String name) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');
    database = await openDatabase(path);

    await database?.rawUpdate('UPDATE Meals SET isfavorite = ? WHERE name = ?',
        [!isFavorite, name]).then((value) async {
      print('Done');
      // تحديث قائمة الوجبات
      await getData(); // إعادة جلب البيانات بعد التحديث
      emit(UpdateDataSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(UpdateDataErrorState());
    });
  }

  List<Map> listFavourite = [];

  getFavoriteData() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');
    database = await openDatabase(path);
    await database!.rawQuery(
        'SELECT * FROM Meals WHERE isfavorite = ?', [true]).then((value) {
      listFavourite = value;
      emit(GetDataSuccessState());
      print(listFavourite);
    }).catchError((onError) {
      emit(GetDataErrorState());
      print(onError.toString());
    });
  }

  List<Map> myAccount = [];

  initSqlLogin() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Table to store meal data
      await db.execute('''CREATE TABLE Account (
          id INTEGER PRIMARY KEY, 
          username TEXT,
          password TEXT
          )
          ''');
    });
  }

  getAccountData() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account.db');
    database = await openDatabase(path);
    await database!.rawQuery('SELECT * FROM Account').then((value) {
      myAccount = value;
      emit(GetDataSuccessState());
      print(myAccount);
    }).catchError((onError) {
      emit(GetDataErrorState());
      print(onError.toString());
    });
  }

  insertAccount(String? username, String? password) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account.db');
    database = await openDatabase(path);

    await database!.rawInsert(
        'INSERT INTO Account(username, password) VALUES(?,?)',
        [username, password]).then((value) {
      print('Inserted account successfully');
    }).catchError((onError) {
      print('Error inserting account: $onError');
    });
  }

  mydeleteAccountDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'account.db');
    await deleteDatabase(path);
    print('database account was deleted');
  }

  updateAccount(String username, String newPassword) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'account.db');
    database = await openDatabase(path);

    await database?.rawUpdate(
        'UPDATE Account SET password = ? WHERE username = ?',
        [newPassword, username]).then((value) async {
      print('Done');
      // تحديث قائمة الوجبات
      await getAccountData(); // إعادة جلب البيانات بعد التحديث
      emit(UpdateDataSuccessState());
    }).catchError((onError) {
      print(onError.toString());
      emit(UpdateDataErrorState());
    });
  }
}
