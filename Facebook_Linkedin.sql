Use master
Go
CREATE DATABASE FaceLinked
Go
Use FaceLinked
Go

CREATE TABLE MEMBER
(
	Member_id int NOT NULL IDENTITY (1,1),
	Fname nvarchar(20) NOT NULL,
	Lname nvarchar(25) NOT NULL,
	Email nvarchar(50) NOT NULL,
	Password nvarchar(20) NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Member_id),
	Unique (Email),

	CONSTRAINT Password_Const CHECK(len(Password) >= 6)
);

CREATE TABLE ORGANIZATION
(
	Organization_id int NOT NULL IDENTITY(1,1),
	Name nvarchar(40) NOT NULL,
	City nvarchar(167) NOT NULL,
	PRIMARY KEY(Organization_id)
);

CREATE TABLE JOB_OFFER
(
	Job_offer_id int NOT NULL IDENTITY(1,1),
	Organization_id int NOT NULL,
	Offer_date date NOT NULL DEFAULT GETDATE(),
	Description nvarchar(500),
	PRIMARY KEY(Job_offer_id),
	FOREIGN KEY(Organization_id) REFERENCES ORGANIZATION(Organization_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE APPLICATION 
(
     Application_id int NOT NULL IDENTITY(1,1),
	 Job_offer_id int NOT NULL,
	 Member_id int NOT NULL,
	 App_date date NOT NULL DEFAULT GETDATE(),
	 PRIMARY KEY(Application_id),
	 FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	 FOREIGN KEY(Job_offer_id) REFERENCES JOB_OFFER(Job_offer_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	 UNIQUE(Job_offer_id,Member_id)
);

CREATE TABLE PRIVACY
(
	Privacy_id int NOT NULL IDENTITY(1,1),
	Privacy_status nvarchar(25)

	PRIMARY KEY(Privacy_id)
);

CREATE TABLE PROFILE
(
	Profile_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Num_of_friends int NOT NULL DEFAULT(0),
	Birth_date date NOT NULL,
	Sex nvarchar(10) NOT NULL CHECK (Sex='Male' OR SEX='Female'),
	Marital_status nvarchar(10) NOT NULL CHECK (Marital_status='Single' OR Marital_status='Married'),
	Organization_id int,
	Phone nvarchar(15),
	Photo nvarchar(100),
	Privacy int NOT NULL DEFAULT(2),
	Religion nvarchar(30),
	Fav_animal nvarchar(100),
	Fav_artist nvarchar(100),
	Fav_book nvarchar(100),
	Fav_movie nvarchar(100),
	
	PRIMARY KEY(Profile_id),
	UNIQUE(Member_id),
	FOREIGN KEY(Privacy) REFERENCES PRIVACY(Privacy_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Organization_id) REFERENCES ORGANIZATION(Organization_id)
		ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE HOBBIE
(
	Hobbie_id int NOT NULL IDENTITY(1,1),
	Profile_id int NOT NULL,
	Hobbie nvarchar(50),

	PRIMARY KEY(Hobbie_id),
	FOREIGN KEY(Profile_id) REFERENCES PROFILE(Profile_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE ADDRESS
(
	Address_id int NOT NULL IDENTITY(1,1),
	Profile_id int NOT NULL,
	Address nvarchar(75) NOT NULL,
	City nvarchar(167) NOT NULL,
	Country nvarchar(45) NOT NULL,
	Zip nvarchar(15) NOT NULL,
	Privacy int NOT NULL DEFAULT(1),

	PRIMARY KEY(Address_id),
	FOREIGN KEY(Profile_id) REFERENCES PROFILE(Profile_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Privacy) REFERENCES PRIVACY(Privacy_id),
	UNIQUE(Profile_id)
);

CREATE TABLE FRIEND
(
	Friend_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Friend_member_id int NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Friend_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Friend_member_id) REFERENCES MEMBER(Member_id),
	UNIQUE(Member_id,Friend_member_id),

	CONSTRAINT Friend_const CHECK (Member_id != Friend_member_id)
);

CREATE TABLE STATUS
(
	Status_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Thumbs_up int NOT NULL DEFAULT(0),
	Thumbs_down int NOT NULL DEFAULT(0),
	Message nvarchar(255) NOT NULL,
	To_twitter bit NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),
	Privacy int NOT NULL DEFAULT(2),

	PRIMARY KEY(Status_id),
	FOREIGN KEY(Privacy) REFERENCES PRIVACY(Privacy_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
);

CREATE TABLE THUMB_UP_DOWN
(
	Thumb_id int NOT NULL IDENTITY(1,1),
	Status_id int NOT NULL,
	Member_id int NOT NULL,
	Flag bit NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Thumb_id),
	FOREIGN KEY(Status_id) REFERENCES STATUS(Status_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		
);

CREATE TABLE COMMENT
(
	Comment_id int NOT NULL IDENTITY(1,1),
	Status_id int NOT NULL,
	Member_id int NOT NULL,
	Message nvarchar(100),
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Comment_id),
	FOREIGN KEY(Status_id) REFERENCES STATUS(Status_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
);

CREATE TABLE FOLLOW
(
	Member_id int NOT NULL,
	Following_id int NOT NULL,
	Following_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Member_id,Following_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Following_id) REFERENCES MEMBER(Member_id),

	CONSTRAINT Following_const CHECK (Member_id!=Following_id)
);

CREATE TABLE RECOMMEND
(
	Member_id int NOT NULL,
	Recommender_id int NOT NULL,
	Being_rec_id int NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Member_id,Recommender_id,Being_rec_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Being_rec_id) REFERENCES MEMBER(Member_id),
	FOREIGN KEY(Recommender_id) REFERENCES MEMBER(Member_id),

	CONSTRAINT Recommend_1 CHECK (Member_id!=Being_rec_id),
	CONSTRAINT Recommend_2 CHECK (Member_id!=Recommender_id),
	CONSTRAINT Recommend_3 CHECK (Being_rec_id != Recommender_id)
);

CREATE TABLE MESSAGE
(
	Message_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	To_user int NOT NULL,
	Message nvarchar(500),
	is_read bit NOT NULL default(0),
	Created_at smalldatetime NOT NULL DEFAULT CAST(GETDATE() as smalldatetime),
	is_spam bit,

	PRIMARY KEY(Message_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(To_user) REFERENCES MEMBER(Member_id),
);

CREATE TABLE NOTIFICATION
(
	Notification_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Comment_id int DEFAULT(NULL),
	Thumb_id int DEFAULT(NULL),
	Msg nvarchar(100) NOT NULL,
	Created_at smalldatetime NOT NULL DEFAULT GETDATE(),

	PRIMARY KEY(Notification_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id),
	FOREIGN KEY(Comment_id) REFERENCES COMMENT(Comment_id),
	FOREIGN KEY(Thumb_id) REFERENCES THUMB_UP_DOWN(Thumb_id)
		ON UPDATE CASCADE ON DELETE SET DEFAULT,
);

CREATE TABLE CV
(
	Cv_id int NOT NULL IDENTITY(1,1),
	Member_id int NOT NULL,
	Cv_title nvarchar(20) NOT NULL,

	PRIMARY KEY(Cv_id),
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
);

CREATE TABLE LANGUAGE_LEVEL
(
	Level_id int NOT NULL IDENTITY(1,1),
	Level_name nvarchar(30) NOT NULL,

	PRIMARY KEY(Level_id)
);

CREATE TABLE LANGUAGE
(
	Language_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Language nvarchar(30) NOT NULL,
	Level_id int NOT NULL,

	PRIMARY KEY(Language_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Level_id) REFERENCES LANGUAGE_LEVEL(Level_id)
);

CREATE TABLE EDUCATION
(
	Education_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	School_name nvarchar(100),
	Start_date date NOT NULL,
	Ending_date date NOT NULL,

	PRIMARY KEY(Education_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT Date_const CHECK ( Start_date < Ending_date)
);

CREATE TABLE WORK_EXPERIENCE
(
	Work_exp_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Company_name nvarchar(100) NOT NULL,
	Info_about_work nvarchar(40) NOT NULL,
	Start_date date NOT NULL,
	Leaving_date date,

	PRIMARY KEY(Work_exp_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    
	CONSTRAINT Date_work_const CHECK (Start_date < Leaving_date)
);

CREATE TABLE SKILL
(
	Skill_id int NOT NULL IDENTITY(1,1),
	Cv_id int NOT NULL,
	Skill nvarchar(40) NOT NULL,

	PRIMARY KEY(Skill_id),
	FOREIGN KEY(Cv_id) REFERENCES CV(Cv_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE BOOKMARK_CATEGORY
(
	Bookmark_category_id int NOT NULL IDENTITY(1,1),
	Name nvarchar(30),

	PRIMARY KEY(Bookmark_category_id),
	UNIQUE(Name)
);

CREATE TABLE BOOKMARK
(
	Bookmark_id int NOT NULL IDENTITY(1,1),
	Bookmark_category_id int NOT NULL,
	Title nvarchar(100) NOT NULL,
	Definition nvarchar(100) NOT NULL,
	Creater_id int NOT NULL,
	Rating int NOT NULL DEFAULT(0),

	PRIMARY KEY(Bookmark_id),
	FOREIGN KEY(Bookmark_category_id) REFERENCES BOOKMARK_CATEGORY(Bookmark_Category_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Creater_id) REFERENCES MEMBER(Member_id)
);

CREATE TABLE BOOKMARK_INFO
(
	Bookmark_info_id int NOT NULL IDENTITY(1,1),
	Bookmark_id int NOT NULL,
	Member_id int NOT NULL,
	Favorite bit NOT NULL DEFAULT(0),

	PRIMARY KEY(Bookmark_info_id),
	FOREIGN KEY(Bookmark_id) REFERENCES BOOKMARK(Bookmark_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	
	UNIQUE(Bookmark_id, Member_id)
);

CREATE TABLE FEED_CATEGORY
(
	Feed_category_id int NOT NULL IDENTITY(1,1),
	Name nvarchar(30),

	PRIMARY KEY(Feed_category_id),
	UNIQUE(Name)
);

CREATE TABLE FEED
(
	Feed_id int NOT NULL IDENTITY(1,1),
	Feed_category_id int NOT NULL,
	Creater_id int NOT NULL,
	
	PRIMARY KEY(Feed_id),
	FOREIGN KEY(Feed_category_id) REFERENCES FEED_CATEGORY(Feed_category_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Creater_id) REFERENCES MEMBER(Member_id),
);

CREATE TABLE FEED_INFO
(
	Feed_info_id int NOT NULL IDENTITY(1,1),
	Feed_id int NOT NULL,
	Member_id int NOT NULL,

	PRIMARY KEY(Feed_info_id),
	FOREIGN KEY(Feed_id) REFERENCES FEED(Feed_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(Member_id) REFERENCES MEMBER(Member_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	UNIQUE(Feed_id,Member_id)
);

/*TRIGGERS and ASSERTIONS*/

Use FaceLinked
GO
CREATE TRIGGER TRG_Friend
ON FRIEND
AFTER INSERT
AS BEGIN
	UPDATE PROFILE SET PROFILE.Num_of_friends = PROFILE.Num_of_friends + 1 FROM PROFILE,inserted WHERE PROFILE.Member_id = inserted.Member_id
	UPDATE PROFILE SET PROFILE.Num_of_friends = PROFILE.Num_of_friends + 1 FROM PROFILE,inserted WHERE PROFILE.Member_id = inserted.Friend_member_id

	DECLARE @Member int
	DECLARE @Following int

	INSERT INTO FRIEND(Member_id,Friend_member_id)
	SELECT Friend_member_id,Member_id
	FROM inserted
	
	IF EXISTS(SELECT *
			  FROM FOLLOW,inserted
		      WHERE inserted.Member_id=FOLLOW.Member_id AND inserted.Friend_member_id=FOLLOW.Following_id)
	BEGIN
			  DELETE FROM FOLLOW
			  WHERE FOLLOW.Member_id IN(SELECT inserted.Member_id FROM inserted) 
			  AND FOLLOW.Following_id IN(SELECT inserted.Friend_member_id FROM inserted)
	END
END;

GO
CREATE TRIGGER TRG_Inc_Rating
ON BOOKMARK_INFO
AFTER INSERT
AS BEGIN
	UPDATE BOOKMARK SET BOOKMARK.Rating = BOOKMARK.Rating + 1 FROM BOOKMARK,inserted WHERE BOOKMARK.Bookmark_id IN (inserted.Bookmark_id)
END;

GO
CREATE TRIGGER TRG_Notice_Comment
ON COMMENT
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(MEMBER.Fname + ' ' + MEMBER.Lname + ' senin paylaþýmýna yorum yaptý.') 
	FROM inserted,MEMBER
	WHERE inserted.Member_id=MEMBER.Member_id

	INSERT INTO NOTIFICATION(Member_id,Comment_id,Thumb_id,Msg)
	SELECT STATUS.Member_id,inserted.Comment_id,NULL,@Message
	FROM inserted, STATUS
	WHERE inserted.Status_id=STATUS.Status_id
	
	INSERT INTO FEED(Feed_category_id,Creater_id)
	SELECT 2,Member_id
	FROM inserted
END;

GO
CREATE TRIGGER TRG_Notice_Thumb
ON THUMB_UP_DOWN
AFTER INSERT
AS BEGIN
	DECLARE @Message nvarchar(100)

	SELECT @Message=(MEMBER.Fname + ' ' + MEMBER.Lname) 
	FROM inserted,MEMBER
	WHERE inserted.Member_id = MEMBER.Member_id

	IF(SELECT Flag FROM inserted)=1
	BEGIN
		SELECT @Message = (@Message + ' ' + 'senin paylaþýmýný beðendi.')

		UPDATE STATUS SET STATUS.Thumbs_up=STATUS.Thumbs_up+1
		FROM STATUS,inserted WHERE STATUS.Status_id IN(inserted.Status_id)
	END
	ELSE
	BEGIN
		SELECT @Message = (@Message + ' ' + 'senin paylaþýmýný beðenmedi.')

		UPDATE STATUS SET STATUS.Thumbs_down=STATUS.Thumbs_down+1
		FROM STATUS,inserted WHERE STATUS.Status_id IN(inserted.Status_id)
	END
		
	INSERT INTO NOTIFICATION(Member_id,Comment_id,Thumb_id,Msg)
	SELECT STATUS.Member_id,NULL,inserted.Thumb_id,@Message
	FROM inserted,STATUS
	WHERE STATUS.Status_id=inserted.Status_id
	
	INSERT INTO FEED(Feed_Category_id,Creater_id)
	SELECT 1,Member_id
	FROM inserted
END;

GO
CREATE TRIGGER TRG_Feed
ON STATUS
AFTER INSERT
AS BEGIN
	INSERT INTO FEED(Feed_category_id,Creater_id)
	SELECT 3,MEMBER.Member_id
	FROM inserted,MEMBER
	WHERE inserted.Member_id = MEMBER.Member_id
END;

GO 
CREATE TRIGGER TRG_Bookmark_Creater
ON BOOKMARK
AFTER INSERT
AS BEGIN
	INSERT INTO BOOKMARK_INFO(Bookmark_id,Member_id,Favorite)
	SELECT inserted.Bookmark_id,inserted.Creater_id,1
	FROM inserted
END;

GO
CREATE TRIGGER TRG_Feed_Info
ON FEED
AFTER INSERT
AS BEGIN
	INSERT INTO FEED_INFO(Feed_id,Member_id)
	SELECT Feed_id,FRIEND.Friend_member_id
	FROM inserted,FRIEND
	WHERE inserted.Creater_id = FRIEND.Member_id
	
	INSERT INTO FEED_INFO(Feed_id,Member_id)
	SELECT Feed_id, FOLLOW.Member_id
	FROM inserted,FOLLOW
	WHERE inserted.Creater_id = FOLLOW.Following_id
END;

GO
CREATE TRIGGER TRG_Message_isspam
ON MESSAGE
AFTER INSERT
AS BEGIN
	IF EXISTS ( SELECT *
				FROM FRIEND,inserted
				WHERE FRIEND.Member_id = inserted.Member_id AND FRIEND.Friend_member_id=inserted.To_user)
	BEGIN			
				UPDATE MESSAGE SET MESSAGE.is_spam = 0
				FROM MESSAGE,inserted
				WHERE MESSAGE.Message_id = inserted.Message_id
	END
	ELSE
	BEGIN
				UPDATE MESSAGE SET MESSAGE.is_spam = 1
				FROM MESSAGE,inserted
				WHERE MESSAGE.Message_id = inserted.Message_id				
	END
END;

GO
CREATE TRIGGER Assertion_Check_Friendship
ON RECOMMEND
FOR INSERT
AS BEGIN
  DECLARE @Mem_id int
  DECLARE @Rec_id int
  DECLARE @Being_id int

  SELECT @Mem_id=Member_id,@Rec_id=Recommender_id,@Being_id=Being_rec_id
  FROM inserted

  IF EXISTS ( SELECT *
			  FROM FRIEND
			  WHERE @Mem_id=FRIEND.Member_id AND @Being_id=FRIEND.Friend_member_id)
  BEGIN	  
		print 'Önerinin sunulduðu kiþiyle önerilen kiþi arkadaþ olmamalý..!'
		rollback transaction
  END
  ELSE IF NOT EXISTS ( SELECT *
				  FROM FRIEND
				  WHERE @Mem_id=FRIEND.Member_id AND @Rec_id=FRIEND.Friend_member_id)
  BEGIN
	    print 'Önerinin sunulduðu kiþiyle öneri yapan arkadaþ olmalý..!'
		rollback transaction
  END
END;

GO
CREATE TRIGGER Assertion_Check_Job_Dates
ON APPLICATION
FOR INSERT
AS BEGIN
	DECLARE @O_date date
	DECLARE @A_date date

	SELECT @O_date=JOB_OFFER.Offer_date, @A_date=App_date
	FROM JOB_OFFER,inserted
	WHERE inserted.Job_offer_id=JOB_OFFER.Job_offer_id

	IF(@A_date<@O_date)
	BEGIN
	 print 'Ýþe baþvurma tarihi iþ ilanýnýn tarihinden sonra olmalý..!'
	 rollback transaction
	END
END;

GO 
CREATE TRIGGER Assertion_Privacy_Control_Comment
ON COMMENT
FOR INSERT
AS BEGIN
	DECLARE @Privacy int
	DECLARE @who int
	SELECT @Privacy = (STATUS.Privacy), @who=(STATUS.Member_id)
	FROM STATUS,inserted
	WHERE Status.Status_id = inserted.Status_id

	IF(@Privacy = 1 AND @who != (SELECT Member_id FROM inserted)) /*Just me*/
	BEGIN
		print 'Error - Privacy Control..'
		rollback transaction
	END
	ELSE IF(@Privacy = 2 AND @who != (SELECT Member_id FROM inserted)) /*Just friends*/
	BEGIN
		IF NOT EXISTS (SELECT *
					   FROM inserted,STATUS,FRIEND
					   WHERE inserted.Status_id=STATUS.Status_id AND STATUS.Member_id=FRIEND.Member_id AND 
						 inserted.Member_id=FRIEND.Friend_member_id)
		BEGIN
			    print 'Error - Privacy Control..'
				rollback transaction
		END
	END
END;

GO
CREATE TRIGGER Assertion_Privacy_Control_Thumb
ON THUMB_UP_DOWN
FOR INSERT
AS BEGIN
	DECLARE @Privacy int
	DECLARE @who int
	SELECT  @Privacy = (STATUS.Privacy), @who=(STATUS.Member_id)
	FROM STATUS , inserted
	WHERE Status.Status_id = inserted.Status_id
	
	IF(@Privacy = 1 AND @who != (SELECT Member_id FROM inserted))
	BEGIN
		print 'Error - Privacy Control..'
		rollback transaction
	END
	ELSE IF (@Privacy = 2 AND @who != (SELECT Member_id FROM inserted))
	BEGIN
	     IF NOT EXISTS (Select *
		                FROM inserted,STATUS,FRIEND
						WHERE inserted.Status_id = Status.Status_id AND STATUS.Member_id = FRIEND.Member_id AND
					    inserted.Member_id = FRIEND.Friend_member_id)
		 BEGIN
			print 'Error - Privacy Control..'
			rollback transaction
		 END
	END
END;

GO
CREATE TRIGGER TRG_Set_Rating_ForDelete
ON BOOKMARK_INFO
AFTER DELETE
AS BEGIN
	UPDATE BOOKMARK SET BOOKMARK.Rating = BOOKMARK.Rating-1
	FROM deleted,BOOKMARK
	WHERE deleted.Bookmark_id = BOOKMARK.Bookmark_id
END;

GO
CREATE TRIGGER TRG_After_Delete_Set
ON MEMBER
AFTER DELETE
AS BEGIN
	UPDATE BOOKMARK SET BOOKMARK.Rating = BOOKMARK.Rating-1 
	FROM deleted,BOOKMARK,BOOKMARK_INFO
	WHERE deleted.Member_id = BOOKMARK_INFO.Member_id AND BOOKMARK.Bookmark_id = BOOKMARK_INFO.Bookmark_id
		 
	UPDATE PROFILE SET PROFILE.Num_of_friends = PROFILE.Num_of_friends-1 
	FROM deleted,PROFILE,FRIEND
	WHERE deleted.Member_id = FRIEND.Member_id AND FRIEND.Friend_member_id = PROFILE.Member_id  
END; 
 
GO
CREATE TRIGGER TRG_After_Delete_Set_Thumb
ON THUMB_UP_DOWN
AFTER DELETE
AS BEGIN
	DECLARE @Flag bit
		
	SELECT @Flag = deleted.flag FROM deleted
		
	IF ( @Flag = 1 )
	BEGIN
		UPDATE STATUS SET STATUS.Thumbs_up = STATUS.Thumbs_up -1
		FROM STATUS,deleted
		WHERE STATUS.Status_id = deleted.Status_id
	END
		
	ELSE
	BEGIN
		UPDATE STATUS SET STATUS.Thumbs_down = STATUS.Thumbs_down -1
		FROM STATUS,deleted
		WHERE STATUS.Status_id = deleted.Status_id
	END	
END;		

GO
CREATE TRIGGER TRG_Member_Delete
ON MEMBER
INSTEAD OF DELETE
AS BEGIN
	 DELETE FROM FRIEND
	 WHERE FRIEND.Friend_member_id 
	 IN ( SELECT Member_id	
	      FROM deleted
		)
		
	DELETE FROM THUMB_UP_DOWN
	WHERE THUMB_UP_DOWN.Member_id
	IN ( SELECT Member_id
		 FROM deleted
		)
	
	DELETE FROM COMMENT
	WHERE COMMENT.Member_id
	IN	( SELECT Member_id
		  FROM deleted
		)
	
	DELETE FROM FOLLOW
	WHERE FOLLOW.Following_id
	IN ( SELECT Member_id
	     FROM deleted
		)
		
	DELETE FROM RECOMMEND
	WHERE RECOMMEND.Being_Rec_id
	IN ( SELECT Member_id
	     FROM deleted
		)
	
	DELETE FROM RECOMMEND
	WHERE RECOMMEND.Recommender_id
	IN ( SELECT Member_id
	     FROM deleted
		)
	
	DELETE FROM MESSAGE
	WHERE MESSAGE.To_user
	IN ( SELECT Member_id
	     FROM deleted
		)
		
	DELETE FROM NOTIFICATION
	WHERE NOTIFICATION.Member_id
	IN ( SELECT Member_id
	     FROM deleted
		)
	
	DELETE FROM BOOKMARK
	WHERE BOOKMARK.Creater_id
	IN ( SELECT Member_id
	     FROM deleted
		)
	
	DELETE FROM FEED
	WHERE FEED.Creater_id
	IN ( SELECT Member_id
	     FROM deleted
		)

	DELETE FROM STATUS
	WHERE STATUS.Member_id
	IN ( SELECT Member_id
		 FROM deleted
		)

	DELETE FROM MEMBER WHERE Member_id IN (SELECT Member_id FROM deleted)
END;

GO
CREATE TRIGGER TRG_Delete_Comment
ON COMMENT
INSTEAD OF DELETE
AS BEGIN
	UPDATE NOTIFICATION SET NOTIFICATION.Comment_id=NULL
	WHERE NOTIFICATION.Comment_id
	IN  ( SELECT Comment_id
	      FROM deleted
		)
	DELETE FROM COMMENT WHERE Comment_id IN (SELECT Comment_id FROM deleted)
END;

GO
CREATE TRIGGER TRG_Delete_Friend
ON FRIEND
FOR DELETE
AS BEGIN
	DELETE FROM FRIEND 
	FROM FRIEND,deleted
	WHERE FRIEND.Member_id=deleted.Friend_member_id AND FRIEND.Friend_member_id=deleted.Member_id

	UPDATE PROFILE SET PROFILE.Num_of_friends = PROFILE.Num_of_friends - 1 FROM PROFILE,deleted WHERE PROFILE.Member_id = deleted.Member_id
	UPDATE PROFILE SET PROFILE.Num_of_friends = PROFILE.Num_of_friends - 1 FROM PROFILE,deleted WHERE PROFILE.Member_id = deleted.Friend_member_id
END;

GO
CREATE TRIGGER TRG_Delete_Status
ON STATUS
INSTEAD OF DELETE
AS BEGIN
	DELETE FROM COMMENT WHERE Status_id IN (SELECT Status_id FROM deleted)

	DELETE FROM STATUS WHERE Status_id IN (SELECT Status_id FROM deleted)
END;


/* POPULATE THE DATABASE..! */
 
INSERT INTO LANGUAGE_LEVEL
VALUES('Beginner'),
      ('Elementary'),
	  ('Pre-Intermediate'),
	  ('Intermediate'),
	  ('Upper Intermediate'),
	  ('Advanced');

INSERT INTO BOOKMARK_CATEGORY
VALUES('Group'),
	  ('Page'),
	  ('Event');
	  
INSERT INTO PRIVACY
VALUES('Just me'),
	  ('Just friends'),
	  ('Everybody');

INSERT INTO FEED_CATEGORY
VALUES('THUMB'),
	  ('COMMENT'),
	  ('STATUS');

INSERT INTO ORGANIZATION
VALUES('Osmanlýspor FK','Ankara'),
	  ('Petkim PetroKimya Holding A.Þ.','Ýzmir'),
	  ('Garanti Bankasý','Ýstanbul');

INSERT INTO MEMBER
VALUES('Onurhan','Çelik','celikonurhan@gmail.com','co4444','2014-09-10 20:50'),
	  ('Ahmet','Gül','ahmet.gul9393@gmail.com','ag0202','2014-09-10 21:22'),
	  ('Yýlmaz','Vural','yvural@mynet.com','123456','2014-10-10 13:15'),
	  ('Aylin','Bener','abener@hotmail.com','aa11bb22cc','2014-12-10 11:41'),
	  ('Anýl','Öztürk','anil.ozturk35@gmail.com','buca3535','2014-12-10 09:38'),
	  ('Deniz','Sarý','d.sari@hotmail.com','king55','2014-12-22 21:21');

INSERT INTO PROFILE
VALUES(1,0,'1993-04-22','Male','Single',null,'5353707916','myphoto.jpeg',DEFAULT,'Muslim','Canary','Natalie Portman','Samarkand','Léon'),
	  (2,0,'1993-10-05','Male','Single',null,'5546525492','photo.png',DEFAULT,'Muslim','Fish','Matt Damon','Komiklig','The Departed'),
	  (3,0,'1953-01-01','Male','Married',1,'5553332211',null,DEFAULT,'Muslim',null,null,null,null),
	  (4,0,'1987-12-02','Female','Single',null,'5442213355','ben.jpeg',DEFAULT,'Muslim','Cat','Türkan Þoray','Baþucumda Müzik','Unutursam Fýsýlda'),
	  (5,0,'1993-01-21','Male','Single',null,'5375007115',null,DEFAULT,'Muslim','Cat','Jim Carrey',null,'Eternal Sunshine of the Spotless Mind'),
	  (6,0,'1979-11-24','Male','Married',null,'5079729102','foto.png',DEFAULT,'Muslim','Giraffe','Jude Law','Improbable','Enemy of the Gates');

INSERT INTO HOBBIE
VALUES(1,'Dart'),
	  (1,'Bisiklet'),
	  (4,'Kitap okumak'),
	  (3,'At binmek'),
	  (5,'Film izlemek'),
	  (6,'Tiyatroya gitmek'),
	  (2,'Yüzme'),
	  (1,'Bilgisayar oyunlarý');

INSERT INTO ADDRESS
VALUES(1,'Öðrenci Köyü Bornova','Ýzmir','Türkiye','35100',DEFAULT),
      (2,'Karataþ','Ýzmir','Türkiye','35260',DEFAULT),
	  (3,'Gazi Mah.','Ankara','Türkiye','06560',DEFAULT),
	  (4,'Kadýköy','Ýstanbul','Türkiye','34710',DEFAULT),
	  (5,'Buca','Ýzmir','Türkiye','35390',DEFAULT),
	  (6,'Yeþilyurt','Ýzmir','Türkiye','35160',DEFAULT);

INSERT INTO CV
VALUES(1,'CV'),
	  (2,'CV'),
	  (3,'CV'),
	  (4,'CV'),
	  (5,'CV'),
	  (6,'CV');

INSERT INTO LANGUAGE
VALUES(1,'English',4),
	  (2,'English',5),
	  (5,'English',4),
	  (3,'English',3),
	  (4,'English',4),
	  (4,'German',2),
	  (3,'German',4);

INSERT INTO EDUCATION
VALUES(1,'Ömer Seyfettin Lisesi','2007','2011'),
      (1,'Ege Üniversitesi - Bilgisayar Mühendisliði','2011','2016'),
	  (2,'Ýzmir Atatürk Lisesi','2010','2011'),
	  (2,'Ege Üniversitesi - Bigisayar Mühendisliði','2011','2016'),
	  (5,'Ege Üniversitesi - Bigisayar Mühendisliði','2011','2016'),
	  (3,'Adapazarý Lisesi','1970','1974'),
	  (3,'19 Mayýs Gençlik ve Spor Akademisi','1975','1979'),
	  (4,'ODTÜ - Kimya Mühendisliði','2005','2010'),
	  (6,'Ýstanbul Üniversitesi - Hukuk', '1998','2002');

INSERT INTO WORK_EXPERIENCE
VALUES(3,'Kasýmpaþa SK','Teknik Direktör','2009','2012'),
      (3,'Antalyaspor SK','Teknik Direktör','2005','2007'),
	  (6,'Adalet Hukuk Bürosu','Avukat','2005','2010'),
	  (4,'Çimentaþ Çimento Fabrikasý','Stajyer','2009-07-10','2009-08-20'),
	  (4,'Acar Boya Sanayi','Üretim Mühendisi','2006','2009');
	  

INSERT INTO SKILL
VALUES(1,'C'),
      (1,'C#'),
	  (2,'C'),
      (2,'C#'),
	  (5,'C'),
      (5,'C#'),
	  (4,'Microsoft Excel'),
	  (4,'Autocad'),
	  (3,'Coaching'),
	  (3,'Motivation'),
	  (1,'Microsoft Office'),
	  (1,'Windows'),
	  (2,'Technology'),
	  (4,'Problem Solving'),
	  (4,'Industrial Experience'),
	  (6,'Critical Thinking'),
	  (6,'Investigative'),
	  (1,'Microsoft SQL Server');

INSERT INTO FRIEND VALUES(1,2,'2014-09-10 22:15');
INSERT INTO FRIEND VALUES(1,5,'2014-12-15 21:00');
INSERT INTO FRIEND VALUES(2,5,DEFAULT);
INSERT INTO FRIEND VALUES(1,4,DEFAULT);
INSERT INTO FRIEND VALUES(4,6,DEFAULT);
INSERT INTO FRIEND VALUES(3,6,DEFAULT);

INSERT INTO BOOKMARK VALUES(1,'Sinema Aþýklarý','Film önerme vs.',4,DEFAULT);
INSERT INTO BOOKMARK VALUES(2,'Fenerbahçe','Fan page',1,DEFAULT);
INSERT INTO BOOKMARK VALUES(3,'Bil-Müh Party','20 Þubatta Eðlenmeye hazýr mýyýz?',2,DEFAULT);

INSERT INTO BOOKMARK_INFO VALUES(1,1,1);
INSERT INTO BOOKMARK_INFO VALUES(3,1,DEFAULT);
INSERT INTO BOOKMARK_INFO VALUES(3,5,1);
INSERT INTO BOOKMARK_INFO VALUES(2,3,1);
INSERT INTO BOOKMARK_INFO VALUES(1,6,DEFAULT);
INSERT INTO BOOKMARK_INFO VALUES(2,6,DEFAULT);

INSERT INTO FOLLOW VALUES(5,3,DEFAULT);
INSERT INTO FOLLOW VALUES(3,4,DEFAULT);

INSERT INTO RECOMMEND VALUES(1,4,6,DEFAULT);
INSERT INTO RECOMMEND VALUES(2,1,4,DEFAULT);

INSERT INTO JOB_OFFER VALUES (2,'2014-10-01','Deneyimli Kimya Mühendisi');
INSERT INTO JOB_OFFER VALUES (3,'2014-11-05','Geliþmeye açýk yeni mezun Bilgisayar Mühendisi');

INSERT INTO APPLICATION VALUES(1,4,'2014-10-06');
INSERT INTO APPLICATION VALUES(2,1,'2014-11-06');
INSERT INTO APPLICATION VALUES(2,2,'2014-11-07');
INSERT INTO APPLICATION VALUES(2,5,DEFAULT);

INSERT INTO MESSAGE VALUES(1,5,'Partiye gidiyoz mu??',DEFAULT,'2014-12-15 20:42',null);
INSERT INTO MESSAGE VALUES(5,1,'Ýstanbulda olabilirim o tarihte duruma göre bakarýz.',DEFAULT,'2014-12-15 20:45',null);
INSERT INTO MESSAGE VALUES(1,5,'Tamamdýr..',DEFAULT,'2014-12-15 20:46',null);

INSERT INTO MESSAGE VALUES(5,3,'Ýyi maçtý hocam.',DEFAULT,DEFAULT,null);

INSERT INTO MESSAGE VALUES(3,6,'Bizim dava ne oldu avukat bey',DEFAULT,'2014-11-09 14:51',null);
INSERT INTO MESSAGE VALUES(6,3,'Her þey iyi görünüyor hocam',DEFAULT,'2014-11-09 15:12',null);

INSERT INTO STATUS VALUES(1,DEFAULT,DEFAULT,'Herkesin yeni yýlý kutlu olsun.',1,'2014-12-28 23:21',DEFAULT);
INSERT INTO STATUS VALUES(4,DEFAULT,DEFAULT,'Kordonda balýk sefasý.. foto.jpg',0,'2014-11-30 20:50',DEFAULT);
INSERT INTO STATUS VALUES(3,DEFAULT,DEFAULT,'Umarým sonraki maç daha iyi oynarýz.',1,'2014-12-05 21:02',3);

INSERT INTO THUMB_UP_DOWN VALUES(1,2,1,'2014-12-28 23:26');
INSERT INTO THUMB_UP_DOWN VALUES(1,4,1,'2014-12-29 08:22');
INSERT INTO THUMB_UP_DOWN VALUES(1,5,1,'2014-12-29 14:32');
INSERT INTO THUMB_UP_DOWN VALUES(2,1,1,'2014-11-30 21:38');
INSERT INTO THUMB_UP_DOWN VALUES(2,6,1,DEFAULT);
INSERT INTO THUMB_UP_DOWN VALUES(3,1,0,DEFAULT);
INSERT INTO THUMB_UP_DOWN VALUES(3,5,1,DEFAULT);

INSERT INTO COMMENT VALUES(1,2,'Senin de Onurhan..','2014-12-28 23:27');

INSERT INTO COMMENT VALUES(2,1,'oo afiyet olsun..','2014-11-30 21:39');
INSERT INTO COMMENT VALUES(2,4,'gel beraber olsun.','2014-11-30 21:45');

INSERT INTO COMMENT VALUES(3,5,'iddaa yattý hocam ya','2014-12-05 22:02');



/*7.a) Write sample INSERT, DELETE and UPDATE statements.. */

INSERT INTO MEMBER(Fname,Lname,Email,Password) 
VALUES('Cengiz','Bursalýoðlu','cengiz_b@gmail.com','2583691');

INSERT INTO PROFILE(Birth_date,Fav_animal,Fav_artist,Fav_book,Fav_movie,Marital_status,Member_id,Sex,Privacy)
VALUES('2014-02-09','Dog','Keremcem','Beyazýt','Av Mevsimi','Single','7','Male',DEFAULT);

INSERT INTO ADDRESS(Address,City,Country,Privacy,Profile_id,Zip) 
VALUES('Niksar','TOKAT','Türkiye',DEFAULT,'7','846845');

INSERT INTO FRIEND VALUES(7,1,DEFAULT);
INSERT INTO THUMB_UP_DOWN VALUES(1,7,1,DEFAULT);

UPDATE ADDRESS SET City='Ýzmir' , Address = 'Bornova'  WHERE ADDRESS.Profile_id  
IN ( SELECT PROFILE.Profile_id 
       FROM PROFILE,MEMBER
       WHERE PROFILE.Profile_id = Member.Member_id AND MEMBER.Fname = 'Cengiz' );

UPDATE PROFILE SET Phone = '05055555555'  WHERE PROFILE.Member_id = 7;

DELETE FROM ADDRESS WHERE ADDRESS.Address = 'Bornova';
DELETE FROM MEMBER WHERE Member_id=7;


/*QUERIES - SELECT Statements  */

/*QUERY 1
Member_no=1 olan kiþiye gelen bildirimlerin yaratýcýlarýnýn Member_id'sini ve
bildirim mesajlarýný veren sorgu.*/

(SELECT COMMENT.Member_id,  NOTIFICATION.Msg
FROM NOTIFICATION,COMMENT
WHERE NOTIFICATION.Member_id=1 AND NOTIFICATION.Comment_id=COMMENT.Comment_id)
UNION
(SELECT THUMB_UP_DOWN.Member_id, NOTIFICATION.Msg
FROM NOTIFICATION,THUMB_UP_DOWN
WHERE NOTIFICATION.Member_id=1 AND NOTIFICATION.Thumb_id=THUMB_UP_DOWN.Thumb_id)

/*QUERY 2
Job_offer_id=2 olan iþ ilanýna baþvuru yapan adaylarýn Ýngilizce dilini bilenlerin ad,soyad ve Ýngilizce seviyelerini veren
sorguyu yazýnýz. Sýralamayý dil seviyelerini azalacak þekilde yapýnýz.
*/

SELECT MEMBER.Fname, MEMBER.Lname, LANGUAGE.Level_id
FROM APPLICATION,MEMBER,CV,LANGUAGE
WHERE APPLICATION.Job_offer_id=2 AND APPLICATION.Member_id=MEMBER.Member_id AND MEMBER.Member_id=CV.Member_id
AND CV.Cv_id=LANGUAGE.Cv_id AND LANGUAGE.Language LIKE 'English'
ORDER BY LANGUAGE.Level_id DESC

/*QUERY 3
Adres þehri Ýzmir olanlarý ad-soyad'a göre alfabetik þekilde sýralayan
Member_id, ad, soyad çýktýsýný veren sorguyu yazýnýz.
*/

SELECT MEMBER.Member_id,MEMBER.Fname, MEMBER.Lname
FROM ADDRESS,PROFILE,MEMBER
WHERE ADDRESS.City = 'Ýzmir' AND ADDRESS.Profile_id = PROFILE.Profile_id AND PROFILE.Member_id=MEMBER.Member_id
ORDER BY Fname,Lname

/*QUERY 4
Member_id=6 olan kiþinin arkadaþlarýný ad,soyad þeklinde listeleyiniz.
*/

SELECT MEMBER.Fname,MEMBER.Lname
FROM MEMBER
WHERE MEMBER.Member_id IN (SELECT FRIEND.Friend_member_id
					       FROM MEMBER,FRIEND
						   WHERE MEMBER.Member_id=6 AND MEMBER.Member_id=FRIEND.Member_id)

/*QUERY 5
Member_id=5 olan kiþiye gelen mesajlarý gönderen kiþinin ad,soyadýný ve mesajý veren sorguyu yazýnýz.
*/

SELECT MEMBER.Fname,MEMBER.Lname,MESSAGE.Message
FROM MESSAGE,MEMBER
WHERE MESSAGE.Member_id=MEMBER.Member_id AND 
				MESSAGE.Message_id IN (SELECT MESSAGE.Message_id
									   FROM MESSAGE
							           WHERE MESSAGE.To_user=5) 

/*QUERY 6
Mail adresinin uzantýsý gmail.com olan kiþilerin ad soyadlarýný veren sorguyu yazýnýz.
*/						
SELECT Fname,Lname
FROM MEMBER
WHERE MEMBER.Email LIKE '%gmail.com%'


/*QUERY 7
Tüm kayýtlý kiþileri arkadaþ sayýlarý azalan þekilde ad,soyad ve arkadaþ sayýlarýný veren sorguyu yazýnýz.
*/

SELECT Fname,Lname,Num_of_friends
FROM MEMBER,PROFILE
WHERE MEMBER.Member_id = PROFILE.Member_id
ORDER BY Num_of_friends DESC

/*QUERY 8
Kullanýcýlarýn Member_id'lerini ve her kullanýcýnýn attýklarý toplam mesaj sayýsýný veren sorgu..
*/

SELECT Member_id,COUNT(Member_id) as Number_of_Message
FROM MESSAGE
GROUP BY Member_id

/*QUERY 9
Member_id=1 olan kullanýcýnýn favoriye aldýðý bookmark sayýsýný veren sorgu..
*/

SELECT COUNT(Favorite) as Number_of_fav
FROM BOOKMARK_INFO
WHERE BOOKMARK_INFO.Member_id=1 AND BOOKMARK_INFO.Favorite=1

/*QUERY 10
Ýzmir'deki firmalarýn açtýðý iþ ilanlarýný veren sorgu..*/

SELECT JOB_OFFER.Job_offer_id,JOB_OFFER.Description
FROM JOB_OFFER , ORGANIZATION
WHERE JOB_OFFER.Organization_id = ORGANIZATION.Organization_id AND ORGANIZATION.City ='Ýzmir';

