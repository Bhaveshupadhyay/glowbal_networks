abstract class NavigationState{}

class CurrentIndexState extends NavigationState{
  final int index;

  CurrentIndexState(this.index);
}