--  Чтобы залить заново: раскомментируй строку ниже.
--  ВНИМАНИЕ: она стирает ВСЕ данные в таблицах и сбрасывает счётчики id.

-- TRUNCATE prescriptions, certificates, sick_leaves, analyses, appointments, schedule, services, doctors, specialties, administrators, patients RESTART IDENTITY CASCADE;

-- 1. СПЕЦИАЛЬНОСТИ

INSERT INTO
    specialties (name)
VALUES ('Терапевт'),
    ('Стоматолог'),
    ('Гинеколог'),
    ('Уролог'),
    ('Кардиолог'),
    ('Эндокринолог'),
    ('Офтальмолог'),
    ('Косметолог');

-- 2. АДМИНИСТРАТОРЫ

INSERT INTO
    administrators (
        first_name,
        last_name,
        phone,
        email,
        password_hash
    )
VALUES (
        'Сергей',
        'Лаптев',
        '+79657856412',
        'admin@medcenter.test',
        '$2b$12$m1J/WIbnQkB1pMiO..9PT.ImmOro8X/0SCOuRAN0o/pjy6o7jgiGS'
    ),
    (
        'Ольга',
        'Воронова',
        '+79779490446',
        'admin2@medcenter.test',
        '$2b$12$m1J/WIbnQkB1pMiO..9PT.ImmOro8X/0SCOuRAN0o/pjy6o7jgiGS'
    );

-- 3. ВРАЧИ

INSERT INTO
    doctors (
        first_name,
        last_name,
        middle_name,
        specialty_id,
        phone,
        email,
        password_hash
    )
SELECT v.fn, v.ln, v.mn, s.id, v.phone, v.email, '$2b$12$m1J/WIbnQkB1pMiO..9PT.ImmOro8X/0SCOuRAN0o/pjy6o7jgiGS'
FROM (
        VALUES (
                'Мария', 'Соколова', 'Андреевна', 'Терапевт', '+79527948585', 'sokolova@medcenter.test'
            ), (
                'Алексей', 'Никитин', 'Сергеевич', 'Терапевт', '+79856090601', 'nikitin@medcenter.test'
            ), (
                'Павел', 'Громов', 'Иванович', 'Терапевт', '+79265859107', 'gromov@medcenter.test'
            ), (
                'Денис', 'Морозов', 'Андреевич', 'Стоматолог', '+79155668705', 'morozov@medcenter.test'
            ), (
                'Ирина', 'Захарова', 'Олеговна', 'Стоматолог', '+79091451924', 'zaharova@medcenter.test'
            ), (
                'Антон', 'Кравцов', 'Львович', 'Стоматолог', '+79177445321', 'kravtsov@medcenter.test'
            ), (
                'Елена', 'Орлова', 'Викторовна', 'Гинеколог', '+79778039156', 'orlova@medcenter.test'
            ), (
                'Наталья', 'Белова', 'Сергеевна', 'Гинеколог', '+79199415496', 'belova@medcenter.test'
            ), (
                'Андрей', 'Фролов', 'Михайлович', 'Уролог', '+79856325677', 'frolov@medcenter.test'
            ), (
                'Виктор', 'Мельников', 'Павлович', 'Уролог', '+79102043421', 'melnikov@medcenter.test'
            ), (
                'Татьяна', 'Волкова', 'Николаевна', 'Кардиолог', '+79104297813', 'volkova@medcenter.test'
            ), (
                'Михаил', 'Крылов', 'Дмитриевич', 'Кардиолог', '+79109939857', 'krylov@medcenter.test'
            ), (
                'Анна', 'Козлова', 'Игоревна', 'Эндокринолог', '+79604523383', 'kozlova@medcenter.test'
            ), (
                'Олег', 'Тарасов', 'Евгеньевич', 'Эндокринолог', '+79253071992', 'tarasov@medcenter.test'
            ), (
                'Сергей', 'Лебедев', 'Олегович', 'Офтальмолог', '+79872160622', 'lebedev@medcenter.test'
            ), (
                'Вера', 'Дьячкова', 'Анатольевна', 'Офтальмолог', '+79207873195', 'dyachkova@medcenter.test'
            ), (
                'Алина', 'Левина', 'Романовна', 'Косметолог', '+79069510889', 'levina@medcenter.test'
            ), (
                'Дарья', 'Сорокина', 'Игоревна', 'Косметолог', '+79818954052', 'sorokina@medcenter.test'
            )
    ) AS v (fn, ln, mn, sp, phone, email)
    JOIN specialties s ON s.name = v.sp;

-- 4. УСЛУГИ (прайс-лист)
--    specialty_id = NULL: услуга не привязана к врачу
--    price = NULL значит "цена по запросу"

INSERT INTO
    services (
        specialty_id,
        name,
        description,
        price
    )
SELECT s.id, v.name, v.descr, v.price
FROM (
        VALUES (
                'Терапевт', 'Приём терапевта', 'Первичный приём, осмотр, консультация', 2000.00
            ), (
                'Терапевт', 'Повторный приём терапевта', NULL, 1500.00
            ), (
                'Стоматолог', 'Консультация стоматолога', 'Осмотр, план лечения', 1000.00
            ), (
                'Стоматолог', 'Профессиональная гигиена', NULL, 4500.00
            ), (
                'Стоматолог', 'Лечение кариеса', 'Цена зависит от сложности', NULL
            ), (
                'Гинеколог', 'Приём гинеколога', 'Консультация, осмотр', 2200.00
            ), (
                'Гинеколог', 'УЗИ органов малого таза', NULL, 1700.00
            ), (
                'Уролог', 'Приём уролога', 'Консультация, осмотр', 2300.00
            ), (
                'Уролог', 'УЗИ почек и мочевого пузыря', NULL, 1800.00
            ), (
                'Кардиолог', 'Приём кардиолога', 'Консультация, осмотр', 2600.00
            ), (
                'Кардиолог', 'Регистрация ЭКГ', 'С расшифровкой', 1200.00
            ), (
                'Эндокринолог', 'Приём эндокринолога', 'Консультация, осмотр', 2400.00
            ), (
                'Офтальмолог', 'Приём офтальмолога', 'Проверка зрения, осмотр глазного дна', 1900.00
            ), (
                'Офтальмолог', 'Подбор очков', NULL, 1500.00
            ), (
                'Косметолог', 'Лазерная эпиляция (малая зона)', 'Подмышки, верхняя губа, бикини классическое', 1500.00
            ), (
                'Косметолог', 'Лазерная эпиляция (большая зона)', 'Цена зависит от зоны, уточняйте у администратора', NULL
            ), (
                NULL, 'Справка в бассейн', NULL, 600.00
            ), (
                NULL, 'Справка для работы или учёбы', NULL, 800.00
            ), (
                NULL, 'Оформление медицинской книжки', NULL, 3500.00
            ), (
                NULL, 'Продление медицинской книжки', NULL, 2500.00
            ), (
                NULL, 'Взятие мазка', 'Забор материала для анализа', 500.00
            ), (
                NULL, 'Общий анализ крови', NULL, 600.00
            ), (
                NULL, 'Биохимический анализ крови', NULL, 1800.00
            ), (
                NULL, 'Общий анализ мочи', NULL, 400.00
            ), (
                NULL, 'Забор крови из вены', 'Сдача крови на анализы', 250.00
            )
    ) AS v (sp, name, descr, price)
    LEFT JOIN specialties s ON s.name = v.sp;

-- 5. ПАЦИЕНТЫ

INSERT INTO
    patients (
        first_name,
        last_name,
        middle_name,
        birth_date,
        phone,
        email
    )
VALUES (
        'Пётр',
        'Григорьев',
        'Сергеевич',
        '1990-05-14',
        '+79886643556',
        'grigoryev.petr@example.com'
    ),
    (
        'Анна',
        'Иванова',
        'Дмитриевна',
        '1985-11-02',
        '+79038260878',
        NULL
    ),
    (
        'Олег',
        'Смирнов',
        'Петрович',
        '1978-03-21',
        NULL,
        'smirnov.oleg@example.com'
    ),
    (
        'Мария',
        'Кузнецова',
        'Алексеевна',
        '1995-07-30',
        '+79876949901',
        'kuznetsova.maria@example.com'
    ),
    (
        'Иван',
        'Попов',
        'Андреевич',
        '2001-01-09',
        '+79059006715',
        NULL
    ),
    (
        'Екатерина',
        'Васильева',
        'Игоревна',
        '1992-09-17',
        '+79261086534',
        NULL
    ),
    (
        'Дмитрий',
        'Новиков',
        'Александрович',
        '1988-12-25',
        NULL,
        'novikov.dmitry@example.com'
    ),
    (
        'Ольга',
        'Фёдорова',
        'Николаевна',
        '1970-06-05',
        '+79817802455',
        'fedorova.olga@example.com'
    ),
    (
        'Артём',
        'Михайлов',
        'Олегович',
        '2015-04-12',
        '+79172964437',
        NULL
    ),
    (
        'Светлана',
        'Егорова',
        'Викторовна',
        '1999-02-28',
        '+79604587694',
        NULL
    ),
    (
        'Николай',
        'Зайцев',
        'Борисович',
        '1965-10-10',
        '+79179840213',
        NULL
    ),
    (
        'Юлия',
        'Павлова',
        'Андреевна',
        '1983-08-19',
        NULL,
        'pavlova.yulia@example.com'
    );

-- 6. РАСПИСАНИЕ: слоты с 09:00 до 18:00, обед 13:00-14:00, без воскресений.
--    Длина слота у каждого врача своя (15, 30 или 60 минут): длительность приёма = длина слота.

INSERT INTO
    schedule (
        doctor_id,
        work_date,
        start_time,
        end_time
    )
SELECT d.id, current_date + g, s::time, (
        s + make_interval(mins => c.slot_min)
    )::time
FROM doctors d
    JOIN (
        VALUES ('sokolova@medcenter.test', 30), ('nikitin@medcenter.test', 30), ('gromov@medcenter.test', 30), ('morozov@medcenter.test', 30), ('zaharova@medcenter.test', 30), ('kravtsov@medcenter.test', 30), ('orlova@medcenter.test', 30), ('belova@medcenter.test', 30), ('frolov@medcenter.test', 30), ('melnikov@medcenter.test', 30), ('volkova@medcenter.test', 15), ('krylov@medcenter.test', 15), ('kozlova@medcenter.test', 30), ('tarasov@medcenter.test', 30), ('lebedev@medcenter.test', 15), (
                'dyachkova@medcenter.test', 15
            ), ('levina@medcenter.test', 60), ('sorokina@medcenter.test', 60)
    ) AS c (email, slot_min) ON c.email = d.email
    CROSS JOIN generate_series(-7, 14) AS g
    CROSS JOIN LATERAL generate_series(
        timestamp '2000-01-01 09:00', timestamp '2000-01-01 18:00' - make_interval(mins => c.slot_min), make_interval(mins => c.slot_min)
    ) AS s
WHERE
    extract(
        isodow
        FROM current_date + g
    ) <> 7
    AND NOT (
        s::time >= time '13:00'
        AND s::time < time '14:00'
    );

-- 7. ЗАПИСИ НА ПРИЁМ
--    w = 'p' (прошедший рабочий день) или 'f' (будущий), k = номер дня от сегодня.

WITH
    wd AS (
        SELECT work_date, 'p' AS w, row_number() OVER (
                ORDER BY work_date DESC
            ) AS k
        FROM (
                SELECT DISTINCT
                    work_date
                FROM schedule
                WHERE
                    work_date < current_date
            ) x
        UNION ALL
        SELECT work_date, 'f' AS w, row_number() OVER (
                ORDER BY work_date
            ) AS k
        FROM (
                SELECT DISTINCT
                    work_date
                FROM schedule
                WHERE
                    work_date > current_date
            ) y
    )
INSERT INTO
    appointments (
        patient_id,
        schedule_id,
        status,
        cancel_reason
    )
SELECT p.id, s.id, v.status::appointment_status, v.reason
FROM (
        VALUES
            -- прошедшие приёмы
            (
                'Григорьев',
                'sokolova@medcenter.test',
                'p',
                1,
                '10:00',
                'completed',
                NULL
            ),
            (
                'Иванова',
                'orlova@medcenter.test',
                'p',
                2,
                '11:30',
                'completed',
                NULL
            ),
            (
                'Смирнов',
                'frolov@medcenter.test',
                'p',
                3,
                '09:30',
                'completed',
                NULL
            ),
            (
                'Кузнецова',
                'volkova@medcenter.test',
                'p',
                2,
                '15:15',
                'completed',
                NULL
            ),
            (
                'Попов',
                'tarasov@medcenter.test',
                'p',
                4,
                '11:00',
                'completed',
                NULL
            ),
            (
                'Михайлов',
                'nikitin@medcenter.test',
                'p',
                1,
                '12:00',
                'completed',
                NULL
            ),
            (
                'Васильева',
                'orlova@medcenter.test',
                'p',
                5,
                '14:30',
                'no_show',
                NULL
            ),
            -- будущие записи
            (
                'Григорьев',
                'volkova@medcenter.test',
                'f',
                1,
                '09:30',
                'planned',
                NULL
            ),
            (
                'Новиков',
                'sokolova@medcenter.test',
                'f',
                1,
                '10:30',
                'planned',
                NULL
            ),
            (
                'Фёдорова',
                'lebedev@medcenter.test',
                'f',
                2,
                '11:15',
                'planned',
                NULL
            ),
            (
                'Егорова',
                'orlova@medcenter.test',
                'f',
                2,
                '10:00',
                'planned',
                NULL
            ),
            (
                'Зайцев',
                'volkova@medcenter.test',
                'f',
                3,
                '09:00',
                'planned',
                NULL
            ),
            (
                'Павлова',
                'morozov@medcenter.test',
                'f',
                3,
                '16:00',
                'planned',
                NULL
            ),
            (
                'Кузнецова',
                'levina@medcenter.test',
                'f',
                4,
                '12:00',
                'planned',
                NULL
            ),
            -- отменённые
            (
                'Иванова',
                'belova@medcenter.test',
                'f',
                5,
                '09:00',
                'canceled',
                'Врач заболел'
            ),
            (
                'Смирнов',
                'sokolova@medcenter.test',
                'f',
                2,
                '15:00',
                'canceled',
                'Отмена по просьбе пациента'
            )
    ) AS v (
        patient_last,
        doctor_email,
        w,
        k,
        t,
        status,
        reason
    )
    JOIN patients p ON p.last_name = v.patient_last
    JOIN doctors d ON d.email = v.doctor_email
    JOIN wd ON wd.w = v.w
    AND wd.k = v.k
    JOIN schedule s ON s.doctor_id = d.id
    AND s.work_date = wd.work_date
    AND s.start_time = v.t::time;

-- Слоты с живыми записями помечаем занятыми
UPDATE schedule
SET
    status = 'booked'
WHERE
    id IN (
        SELECT schedule_id
        FROM appointments
        WHERE
            status <> 'canceled'
    );

-- Прошедшие слоты без записи закрываем
UPDATE schedule
SET
    status = 'unavailable'
WHERE
    work_date < current_date
    AND status = 'free';

-- Гинеколог Белова заболела на 5-й будущий рабочий день: свободные слоты закрыты
UPDATE schedule s
SET
    status = 'unavailable'
FROM doctors d
WHERE
    d.id = s.doctor_id
    AND d.email = 'belova@medcenter.test'
    AND s.status = 'free'
    AND s.work_date = (
        SELECT work_date
        FROM (
                SELECT DISTINCT
                    work_date
                FROM schedule
                WHERE
                    work_date > current_date
            ) z
        ORDER BY work_date
        OFFSET
            4
        LIMIT 1
    );

-- 8. АНАЛИЗЫ

INSERT INTO
    analyses (
        patient_id,
        appointment_id,
        name,
        analysis_date,
        result,
        file_path,
        comment
    )
SELECT p.id, (
        SELECT a.id
        FROM appointments a
        WHERE
            a.patient_id = p.id
            AND a.status = 'completed'
        ORDER BY a.id
        LIMIT 1
    ), v.name, current_date - v.ago, v.result, v.file_path, v.comment
FROM (
        VALUES (
                'Григорьев', 'Общий анализ крови', 5, 'Гемоглобин 148 г/л, лейкоциты 6,2 x10^9/л, СОЭ 7 мм/ч', NULL, 'Показатели в норме'
            ), (
                'Григорьев', 'Биохимический анализ крови', 5, NULL, 'storage/results/demo_biochem.pdf', 'Результат во вложенном PDF'
            ), (
                'Иванова', 'Мазок на флору', 4, 'Лейкоциты 10-15 в поле зрения', NULL, 'Повторить через 2 недели'
            ), (
                'Смирнов', 'УЗИ почек и мочевого пузыря', 3, NULL, 'storage/results/demo_uzi.pdf', NULL
            ), (
                'Смирнов', 'Общий анализ мочи', 3, 'Цвет соломенный, белок не обнаружен, лейкоциты 1-2', NULL, 'Показатели в норме'
            ), (
                'Кузнецова', 'ЭКГ', 2, 'Ритм синусовый, ЧСС 72 уд/мин', NULL, NULL
            )
    ) AS v (
        patient_last, name, ago, result, file_path, comment
    )
    JOIN patients p ON p.last_name = v.patient_last;

-- 9. БОЛЬНИЧНЫЕ

INSERT INTO
    sick_leaves (
        patient_id,
        doctor_id,
        start_date,
        end_date,
        diagnosis
    )
SELECT p.id, d.id, current_date - v.from_ago, current_date + v.to_ahead, v.diagnosis
FROM (
        VALUES (
                'Смирнов',
                'sokolova@medcenter.test',
                3,
                4,
                'ОРВИ'
            ),
            (
                'Попов',
                'sokolova@medcenter.test',
                10,
                -4,
                'Острый бронхит'
            )
    ) AS v (
        patient_last,
        doctor_email,
        from_ago,
        to_ahead,
        diagnosis
    )
    JOIN patients p ON p.last_name = v.patient_last
    JOIN doctors d ON d.email = v.doctor_email;

-- 10. СПРАВКИ

INSERT INTO
    certificates (
        patient_id,
        doctor_id,
        type,
        issue_date,
        description
    )
SELECT p.id, d.id, v.type, current_date - v.ago, v.descr
FROM (
        VALUES (
                'Григорьев',
                'sokolova@medcenter.test',
                'Справка в бассейн',
                5,
                'Допуск к занятиям плаванием'
            ),
            (
                'Михайлов',
                'nikitin@medcenter.test',
                'Справка для школы',
                1,
                'Практически здоров, допущен к занятиям'
            )
    ) AS v (
        patient_last,
        doctor_email,
        type,
        ago,
        descr
    )
    JOIN patients p ON p.last_name = v.patient_last
    JOIN doctors d ON d.email = v.doctor_email;

-- 11. РЕЦЕПТЫ

INSERT INTO
    prescriptions (
        appointment_id,
        prescription_date,
        medicine,
        dosage,
        instructions
    )
SELECT (
        SELECT a.id
        FROM appointments a
        WHERE
            a.patient_id = p.id
            AND a.status = 'completed'
        ORDER BY a.id
        LIMIT 1
    ), current_date - v.ago, v.medicine, v.dosage, v.instructions
FROM (
        VALUES (
                'Григорьев', 5, 'Витамин D3', '2000 МЕ', 'По 1 капсуле в день во время еды, 1 месяц'
            ), (
                'Михайлов', 1, 'Парацетамол (сироп)', '5 мл', 'При температуре выше 38,5, не чаще 3 раз в сутки'
            )
    ) AS v (
        patient_last, ago, medicine, dosage, instructions
    )
    JOIN patients p ON p.last_name = v.patient_last;

-- СВОДКА

SELECT 'specialties' AS tbl, count(*) AS rows
FROM specialties
UNION ALL
SELECT 'doctors', count(*)
FROM doctors
UNION ALL
SELECT 'services', count(*)
FROM services
UNION ALL
SELECT 'patients', count(*)
FROM patients
UNION ALL
SELECT 'administrators', count(*)
FROM administrators
UNION ALL
SELECT 'schedule', count(*)
FROM schedule
UNION ALL
SELECT 'appointments', count(*)
FROM appointments
UNION ALL
SELECT 'analyses', count(*)
FROM analyses
UNION ALL
SELECT 'sick_leaves', count(*)
FROM sick_leaves
UNION ALL
SELECT 'certificates', count(*)
FROM certificates
UNION ALL
SELECT 'prescriptions', count(*)
FROM prescriptions;