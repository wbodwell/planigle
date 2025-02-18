import { Component, AfterViewInit, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { ParentWorkItemsComponent } from '../parent-work-items.component';
import { SessionsService } from '../../services/sessions.service';
import { StoryAttributesService } from '../../services/story-attributes.service';
import { ProjectionsService } from '../../../premium/services/projections.service';
import { ErrorService } from '../../services/error.service';
import { ProjectsService } from '../../services/projects.service';
import { StoriesService } from '../../services/stories.service';
import { TasksService } from '../../services/tasks.service';
import { DragDropService } from '../../services/drag-drop.service';

@Component({
  selector: 'app-stories',
  templateUrl: './stories.component.html',
  styleUrls: ['./stories.component.css'],
  providers: [StoriesService, TasksService, StoryAttributesService, ProjectsService, ProjectionsService, DragDropService]
})
export class StoriesComponent extends ParentWorkItemsComponent implements AfterViewInit, OnDestroy {
  constructor(
    router: Router,
    route: ActivatedRoute,
    modalService: NgbModal,
    sessionsService: SessionsService,
    storyAttributesService: StoryAttributesService,
    projectsService: ProjectsService,
    storiesService: StoriesService,
    tasksService: TasksService,
    projectionsService: ProjectionsService,
    dragDropService: DragDropService,
    errorService: ErrorService
  ) {
    super(
      router, route, modalService, sessionsService, storyAttributesService, projectsService,
      storiesService, tasksService, projectionsService, dragDropService, errorService);
  }

  getRoute(): string {
    return 'stories';
  }

  showEpics(): boolean {
    return false;
  }
}
