import '../models/post_model.dart';

final List<PostModel> fakePosts = [
  const PostModel(
    id: '1',
    username: 'john_doe',
    userImage: 'https://i.pravatar.cc/150?img=1',
    imageUrl: 'https://picsum.photos/seed/1/400/400',
    caption: 'Beautiful sunset at the beach! 🌅 #travel #sunset',
    likes: 1234,
  ),
  const PostModel(
    id: '2',
    username: 'jane_smith',
    userImage: 'https://i.pravatar.cc/150?img=5',
    imageUrl: 'https://picsum.photos/seed/2/400/400',
    caption: 'Morning coffee vibes ☕️',
    likes: 856,
  ),
  const PostModel(
    id: '3',
    username: 'tech_guru',
    userImage: 'https://i.pravatar.cc/150?img=8',
    imageUrl: 'https://picsum.photos/seed/3/400/400',
    caption: 'Working on something exciting! 💻 #coding #developer',
    likes: 2341,
  ),
  const PostModel(
    id: '4',
    username: 'food_lover',
    userImage: 'https://i.pravatar.cc/150?img=9',
    imageUrl: 'https://picsum.photos/seed/4/400/400',
    caption: 'Delicious pasta made from scratch! 🍝 #foodie #cooking',
    likes: 1567,
  ),
  const PostModel(
    id: '5',
    username: 'nature_explorer',
    userImage: 'https://i.pravatar.cc/150?img=12',
    imageUrl: 'https://picsum.photos/seed/5/400/400',
    caption: 'Mountain hiking adventure 🏔️ #nature #hiking',
    likes: 987,
  ),
];
