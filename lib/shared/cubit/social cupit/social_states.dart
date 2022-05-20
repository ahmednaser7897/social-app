abstract class SocialState{}
class IntiAppState extends SocialState{}
class LodingGetUserData extends SocialState{}
class ScGetUserData extends SocialState{}
class ErrorGetUserData extends SocialState{
  final String error;
  ErrorGetUserData(this.error);
}
//ok
class Mood extends SocialState{}
class ChangLange extends SocialState{}



//ok
class LodingGetAllUserData extends SocialState{}
class ScGetAllUserData extends SocialState{}
class ErrorGetAllUserData extends SocialState{
  final String error;
  ErrorGetAllUserData(this.error);
}
//ok
class ChangBottomBarIndix extends SocialState{}

class AddPostWithImage extends SocialState{}

//ok i
class LodingPickeProfileImage extends SocialState{}
class ScPickeProfileImage extends SocialState{}
class ErrorPickeProfileImage extends SocialState{
  final String error;
  ErrorPickeProfileImage(this.error);
}
//ok i
class LodingUpdateProfileImage extends SocialState{}
class ScUpdateProfileImage extends SocialState{}
class ErrorUpdateProfileImage extends SocialState{
  final String error;
  ErrorUpdateProfileImage(this.error);
}
//ok i
class LodingPickeCoverImage extends SocialState{}
class ScPickeCoverImage extends SocialState{}
class ErrorPickeCoverImage extends SocialState{
  final String error;
  ErrorPickeCoverImage(this.error);
}
//ok i
class LodingUpdateCoverImage extends SocialState{}
class ScUpdateCoverImage extends SocialState{}
class ErrorUpdateCoverImage extends SocialState{
  final String error;
  ErrorUpdateCoverImage(this.error);
}
//ok i
class LodingUpdateProfile extends SocialState{}
class ScUpdateProfile extends SocialState{}
class ErrorUpdateProfile extends SocialState{
  final String error;
  ErrorUpdateProfile(this.error);
}
//ok
class LodingPickePostImage extends SocialState{}
class ScPickePostImage extends SocialState{}
class ErrorPickePostImage extends SocialState{
  final String error;
  ErrorPickePostImage(this.error);
}
//ok
class LodingCreatePost extends SocialState{}
class ScCreatePost extends SocialState{}
class ErrorCreatePost extends SocialState{
  final String error;
  ErrorCreatePost(this.error);
}
//ok
class RemovePostImage extends SocialState{}
//ok
class LodingGetPostsData extends SocialState{}
class ScGetPostsData extends SocialState{}
class ScGetAllPostsData extends SocialState{}
class ErrorGetPostsData extends SocialState{
  final String error;
  ErrorGetPostsData(this.error);
}
//ok
class LodingPostsLik extends SocialState{}
class ScPostsLik extends SocialState{}
class ErrorPostsLik extends SocialState{
  final String error;
  ErrorPostsLik(this.error);
}
//ok
class LodingPostsDisLik extends SocialState{}
class ScPostsDisLik extends SocialState{}
class ErrorPostsDisLik extends SocialState{
  final String error;
  ErrorPostsDisLik(this.error);
}


class LodingAddComment extends SocialState{}
class ScAddComment extends SocialState{}
class ErrorAddComment extends SocialState{}

class LodingGetComment extends SocialState{}
class ScGetComment extends SocialState{}
class ErrorGetComment extends SocialState{}

class LodingDeleteComment extends SocialState{}
class ScDeleteComment extends SocialState{}
class ErrorDeleteComment extends SocialState{}

class EmptyComments extends SocialState{}

class LodingAddPostToFav extends SocialState{}
class ScAddPostToFav extends SocialState{}
class ErrorAddPostToFav extends SocialState{}

class LodingGetFavPost extends SocialState{}
class ScGetFavPost extends SocialState{}
class ErrorGetFavPost extends SocialState{}

class LodingDeleteFromFavp extends SocialState{}
class ScDeleteFromFavp extends SocialState{}
class ErrorDeleteFromFavp extends SocialState{}

class LodingGetMyPosts extends SocialState{}
class ScGetMyPosts extends SocialState{}
class ErrorGetMyPosts extends SocialState{}

class LodingFollowPerson extends SocialState{}
class ScFollowPerson extends SocialState{}
class ErrorFollowPerson extends SocialState{}

class LodingGetFollowings extends SocialState{}
class ScGetFollowings extends SocialState{}
class ScGetAllFollowings extends SocialState{}
class ErrorGetFollowings extends SocialState{}

class LodingGetFollowers extends SocialState{}
class ScGetFollowers extends SocialState{}
class ScGetAllFollowers extends SocialState{}
class ErrorGetFollowers extends SocialState{}

class LodingUnFollowPerson extends SocialState{}
class ScUnFollowPerson extends SocialState{}
class ErrorUnFollowPerson extends SocialState{}

class LodingGetProfileNumbers extends SocialState{}
class ScGetProfileNumbers extends SocialState{}

class LodingSearch extends SocialState{}
class ScSearch extends SocialState{}
class ErrorSearch extends SocialState{}

class ChangeFollow extends SocialState{}



class LodingPickeStoryImage extends SocialState{}
class ScPickeStoryImage extends SocialState{}
class ErrorPickeStoryImage extends SocialState{
  final String error;
  ErrorPickeStoryImage(this.error);
}

class RemoveStoryImage extends SocialState{}

class AddStoryWithImage extends SocialState{}

class LodingCreateStory extends SocialState{}
class ScCreateStory extends SocialState{}
class ErrorCreateStory extends SocialState{
  final String error;
  ErrorCreateStory(this.error);
}
class LodingGetMyStoris extends SocialState{}
class ScGetMyStoris extends SocialState{}
class ErrorGetMyStoris extends SocialState{}

class LodingGetMyStorisItem extends SocialState{}
class ScGetMyStorisItem extends SocialState{}

class ChangStoryIndix extends SocialState{}

class LodingGetAllStoris extends SocialState{}
class ScGetAllStoris extends SocialState{}
class ScGetStoris extends SocialState{}
class ErrorGetAllStoris extends SocialState{}


class EmptyUserData extends SocialState{}


class LodingGetCommentsNumber extends SocialState{}
class ScGetCommentsNumber extends SocialState{}
class ErrorGetCommentsNumber extends SocialState{}

class LodingGetLikesNumber extends SocialState{}
class ScGetLikesNumber extends SocialState{}
class ErrorGetLikesNumber extends SocialState{}

class LodingChangMyPostsPoto extends SocialState{}
class ScChangMyPostsPoto extends SocialState{}
class ErrorChangMyPostsPoto extends SocialState{}
 
 